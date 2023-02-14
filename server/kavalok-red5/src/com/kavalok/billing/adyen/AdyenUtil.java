package com.kavalok.billing.adyen;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.security.SignatureException;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.billing.transaction.BillingTransactionUtil;
import com.kavalok.billing.transaction.RobotTransactionProcessor;
import com.kavalok.billing.transaction.TransactionConstants;
import com.kavalok.billing.transaction.TransactionProcessor;
import com.kavalok.dao.RobotTransactionDAO;
import com.kavalok.dao.TransactionDAO;
import com.kavalok.db.RobotTransaction;
import com.kavalok.db.Transaction;
import com.kavalok.transactions.DefaultTransactionStrategy;

public class AdyenUtil {

  private static Logger logger = LoggerFactory.getLogger("AdyenUtil");

  public static Logger getLogger() {
    return logger;
  }

  public static String processCustomParams(Map<String, String> requestParams) throws IllegalAccessException,
      InvocationTargetException, IOException {

    return "[accepted]\n";
  }

  public static String processResultRequest(Map<String, String> requestParams) throws IllegalAccessException,
      InvocationTargetException, IOException {

    logger.warn("Got params: " + requestParams);

    AdyenRequestParams requestParamsXML = new AdyenRequestParams();

    System.err.println("Adyen requestParams: "+requestParams);
    BeanUtils.populate(requestParamsXML, requestParams);

    if ("true".equals(requestParamsXML.getSuccess())) {
      return processTransaction(requestParamsXML.getMerchantReference(), requestParamsXML);

    } else {
      logger.warn("IPN request was incorrect. Parameters: " + requestParams);
    }
    return "";

  }

  private static String processTransaction(String content, AdyenRequestParams adyenRequestParams) {

    int lastOpenBracketIndex = content.lastIndexOf('(');
    int lastCloseBracketIndex = content.lastIndexOf(')');
    int lastRobotsOpenBracketIndex = content.lastIndexOf("(R");

    boolean isRobotTx = lastRobotsOpenBracketIndex != -1 && lastRobotsOpenBracketIndex == lastOpenBracketIndex;

    Long transactionId;
    try {
      if (isRobotTx) {
        transactionId = new Long(content.substring(lastRobotsOpenBracketIndex + 2, lastCloseBracketIndex));
      } else {
        transactionId = new Long(content.substring(lastOpenBracketIndex + 1, lastCloseBracketIndex));
      }
    } catch (Exception e) {
      transactionId = new Long(content.toString());
    }

    if (isRobotTx) {
      return processRobotTransaction(adyenRequestParams, transactionId);
    } else {
      return processTransaction(adyenRequestParams, transactionId);
    }

  }

  private static String processRobotTransaction(AdyenRequestParams adyenRequestParams, Long transactionId) {
    RobotTransaction tx;

    synchronized (AdyenUtil.class) {
      DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
      try {
        dts.beforeCall();
        RobotTransactionDAO dao = new RobotTransactionDAO(dts.getSession());
        tx = dao.findById(transactionId);
        if (!TransactionConstants.STATE_DONE.equals(tx.getState())) {
          tx = BillingTransactionUtil.setProcessingState(dts.getSession(), tx, dao, adyenRequestParams, "", "");
        }
        dts.afterCall();
      } catch (Exception e) {
        dts.afterError(e);
        logger.error("Error processing transaction", e);
        throw new IllegalStateException("Error calling AdyenUtils.processRobotsTransaction", e);
      }
    }

    logger.info("AdyenUtil processRobotsTransaction Transaction state: " + tx.getState());

    Thread thread = new Thread(new RobotTransactionProcessor(transactionId));
    thread.start();
    return "";

  }

  private static String processTransaction(AdyenRequestParams adyenRequestParams, Long transactionId) {
    Transaction trans;

    synchronized (AdyenUtil.class) {
      DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
      try {
        dts.beforeCall();
        TransactionDAO dao = new TransactionDAO(dts.getSession());
        trans = dao.findById(transactionId);
        if (!TransactionConstants.STATE_DONE.equals(trans.getState())) {
          trans = BillingTransactionUtil.setProcessingState(dts.getSession(), trans, dao, adyenRequestParams, "", "");
        }
        dts.afterCall();
      } catch (Exception e) {
        dts.afterError(e);
        logger.error("Error processing transaction", e);
        throw new IllegalStateException("Error calling AdyenUtils.processTransaction", e);
      }
    }

    logger.info("AdyenUtil processTransaction Transaction state: " + trans.getState());

    Thread thread = new Thread(new TransactionProcessor(transactionId));
    thread.start();
    return trans.getSuccessMessage();
  }

  public static void main(String[] args) throws SignatureException {
    
//    String content = "Rocket Pack 5 (R3)";
//      
//    int lastOpenBracketIndex = content.lastIndexOf('(');
//    int lastCloseBracketIndex = content.lastIndexOf(')');
//    int lastRobotsOpenBracketIndex = content.lastIndexOf("(R");
//
//    boolean isRobotTx = lastRobotsOpenBracketIndex != -1 && lastRobotsOpenBracketIndex == lastOpenBracketIndex;
//
//    Long transactionId;
//    try {
//      if (isRobotTx) {
//        transactionId = new Long(content.substring(lastRobotsOpenBracketIndex + 1, lastCloseBracketIndex));
//      } else {
//        transactionId = new Long(content.substring(lastOpenBracketIndex + 1, lastCloseBracketIndex));
//      }
//    } catch (Exception e) {
//      transactionId = new Long(content.toString());
//    }
//
//      System.out.println(transactionId);
    
//    Transaction tr = new Transaction();
//    User user = new User();
//
//    user.setId(84l);
//    user.setLogin("someChobot");
//    user.setEmail("chobotsuser@google.com");
//
//    tr.setId(34774l);
//
//    // System.err.println(generatePaymentFormParams(tr));
  }

}
