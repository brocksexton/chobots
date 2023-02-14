package com.kavalok.billing.adyen.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;

import com.kavalok.billing.adyen.AdyenUtil;
import com.kavalok.utils.HttpUtil;

//http://kavalok.com:5080/kavalok/smscoinresult?merchantReference=12432&skinCode=W3mz1Nf0&shopperLocale=en&paymentMethod=visa&authResult=AUTHORISED&pspReference=8512319300311403&merchantSig=DWqA%2Bhy7uAChEuDxwh%2Fpf%2FXK2G0%3D
//http://kavalok.com:5080/kavalok/smscoinresult?merchantReference=12433&skinCode=W3mz1Nf0&shopperLocale=en&paymentMethod=mc  &authResult=REFUSED   &pspReference=8512319303481427&merchantSig=Rmk3fTW4y6DF6L%2Fr00rjC1KVI%2BY%3D

public class AdyenCutomParamsServlet extends HttpServlet {

  private static final long serialVersionUID = -8701983456152313300L;

  private static String ALLOWED = "allowed";

  private static String DECLINED = "declined";

  HashMap<String, String> users = new HashMap<String, String>();

  private static Logger logger = AdyenUtil.getLogger();

  @Override
  public void init(ServletConfig config) throws ServletException {
    super.init(config);

    // Names and passwords are case sensitive!
    users.put("chobotsrock:abrakadabra41032", ALLOWED);
    // users.put("username2:password2", ALLOWED);
    users.put("username3:password3", DECLINED);
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
    String auth = req.getHeader("Authorization");

    // Do we allow that user?
    if (!allowUser(auth)) {
      // Not allowed, so report unauthorized
      res.setHeader("WWW-Authenticate", "BASIC realm=\"Protected Page\"");
      res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
    } else {
      String result = "[accepted]\n";
      try {
        result = AdyenUtil.processCustomParams(HttpUtil.normalizeRequestParameteres(req.getParameterMap()));
      } catch (IllegalAccessException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      } catch (InvocationTargetException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      out.println(result);
    }
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
