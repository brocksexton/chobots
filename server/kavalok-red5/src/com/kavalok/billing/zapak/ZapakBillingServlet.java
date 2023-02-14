package com.kavalok.billing.zapak;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.billing.adyen.HmacEncoder;
import com.kavalok.billing.transaction.BillingTransactionUtil;
import com.kavalok.billing.transaction.TransactionConstants;
import com.kavalok.billing.transaction.TransactionProcessor;
import com.kavalok.dao.TransactionDAO;
import com.kavalok.db.Transaction;
import com.kavalok.transactions.DefaultTransactionStrategy;
import com.kavalok.utils.HttpUtil;

public class ZapakBillingServlet extends HttpServlet {

  private static final long serialVersionUID = -8701983456152313300L;

  private static String SECRET_KEY;

  private static String ALLOWED = "allowed";

  // private static String DECLINED = "declined";

  HashMap<String, String> users = new HashMap<String, String>();

  private static Logger logger = LoggerFactory.getLogger("ZapakBillingServlet");

  private static boolean useTest = "true".equals(System.getProperty("isTestServer"));

  @Override
  public void init(ServletConfig config) throws ServletException {
    super.init(config);

    // Names and passwords are case sensitive!
    users.put("chobotsin:24bebfcbc28e081e4f", ALLOWED);

    SECRET_KEY = useTest ? ZapakProperties.getInstance().getSecretInKeySanbox() : ZapakProperties.getInstance()
        .getSecretInKeyLive();

  }

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    doPost(req, res);
  }

  @Override
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    res.setContentType("text/plain");
    PrintWriter out = res.getWriter();

    // Get Authorization header
    // String auth = req.getHeader("Authorization");

    // Do we allow that user?
    // if (!allowUser(auth)) {
    // // Not allowed, so report unauthorized
    // res.setHeader("WWW-Authenticate", "BASIC realm=\"Protected Page\"");
    // res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
    // } else {
    try {
      Map<String, String> requestParams = HttpUtil.normalizeRequestParameteres(req.getParameterMap());
      logger.warn("Got params: " + requestParams);

      ZapakRequestParams requestParamsXML = new ZapakRequestParams();

      BeanUtils.populate(requestParamsXML, requestParams);

      String hmacData = requestParamsXML.getOrder_id() + "," + requestParamsXML.getTransaction_id() + ","
          + requestParamsXML.getStatus();
      String enc = HmacEncoder.calculateRFC2104HMAC(hmacData, SECRET_KEY);
      if (!enc.equals(requestParamsXML.getEnc())) {
        out.println("[wrong params!]\n");
        return;
      } else if (!"Y".equals(requestParamsXML.getStatus())) {
        out.println("[payment not accepted!]\n");
        return;
      } else {
        processTransaction(requestParamsXML.getOrder_id(), requestParamsXML);
      }

    } catch (Exception e) {
      logger.error("Error processing request", e);
    }
    // Allowed
    out.println("[accepted]\n");
    // }
  }

  private String processTransaction(String transactionIdStr, ZapakRequestParams requestParamsXML) {

    Long transactionId = new Long(transactionIdStr.toString());

    Transaction trans;

    synchronized (ZapakBillingServlet.class) {
      DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
      try {
        dts.beforeCall();
        TransactionDAO dao = new TransactionDAO(dts.getSession());
        trans = dao.findById(transactionId, false);
        if (!TransactionConstants.STATE_DONE.equals(trans.getState())) {
          trans = BillingTransactionUtil.setProcessingState(dts.getSession(), trans, dao, requestParamsXML, "", "");
        }
        dts.afterCall();
      } catch (Exception e) {
        dts.afterError(e);
        logger.error("Error processing transaction", e);
        throw new IllegalStateException("Error calling ZapakBillingServlet.processTransaction", e);
      }
    }

    logger.info("ZapakBillingServlet processTransaction Transaction state: " + trans.getState());

    Thread thread = new Thread(new TransactionProcessor(transactionId));
    thread.start();
    return trans.getSuccessMessage();

  }

  // This method checks the user information sent in the Authorization
  // header against the database of users maintained in the users HashMap.
  protected boolean allowUser(String auth) {
    if (auth == null)
      return false; // no auth

    if (!auth.toUpperCase().startsWith("BASIC ")) {
      return false; // we only do BASIC
    }

    // Get encoded user and password, comes after "BASIC "
    String userpassEncoded = auth.substring(6);

    logger.error("userpassEncoded: " + userpassEncoded);

    // Decode it, using any base 64 decoder (we use com.oreilly.servlet)
    String userpassDecoded = new String(Base64.decodeBase64(userpassEncoded.getBytes()));

    logger.error("userpassDecoded: " + userpassDecoded);

    // Check our user list to see if that user and password are "allowed"
    if (ALLOWED.equals(users.get(userpassDecoded))) {
      return true;
    }
    return false;
  }
}
