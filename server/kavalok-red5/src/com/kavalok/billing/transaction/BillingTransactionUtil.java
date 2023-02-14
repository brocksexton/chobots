package com.kavalok.billing.transaction;

import java.io.StringWriter;

import org.hibernate.Session;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.load.Persister;

import com.kavalok.dao.RobotSKUDAO;
import com.kavalok.dao.RobotTransactionDAO;
import com.kavalok.dao.SKUDAO;
import com.kavalok.dao.TransactionDAO;
import com.kavalok.db.RobotSKU;
import com.kavalok.db.RobotTransaction;
import com.kavalok.db.SKU;
import com.kavalok.db.Transaction;
import com.kavalok.db.User;

public class BillingTransactionUtil {

  public static Transaction setProcessingState(Session session, Long transactionId, Object xmlObjectRequestParams,
      String payedAmount, String currency) throws Exception {
    TransactionDAO dao = new TransactionDAO(session);
    Transaction trans = dao.findById(transactionId, false);
    return setProcessingState(session, trans, dao, xmlObjectRequestParams, payedAmount, currency);
  }

  public static Transaction setProcessingState(Session session, Transaction trans, TransactionDAO dao,
      Object xmlObjectRequestParams, String payedAmount, String currency) throws Exception {
    trans.setState(TransactionConstants.STATE_PROCESSING);

    Serializer serializer = new Persister();
    StringWriter writer = new StringWriter();
    serializer.write(xmlObjectRequestParams, writer);
    trans.setBillingRequestParams(writer.toString());
    trans.setPayedAmount(payedAmount);
    trans.setPayedCurrency(currency);

    dao.makePersistent(trans);
    return trans;
  }

  public static RobotTransaction setProcessingState(Session session, RobotTransaction tx, RobotTransactionDAO dao,
      Object xmlObjectRequestParams, String payedAmount, String currency) throws Exception {
    tx.setState(TransactionConstants.STATE_PROCESSING);

    Serializer serializer = new Persister();
    StringWriter writer = new StringWriter();
    serializer.write(xmlObjectRequestParams, writer);
    tx.setBillingRequestParams(writer.toString());

    dao.makePersistent(tx);
    return tx;
  }

  public static Transaction setWrongRequestState(Session session, Long transactionId) throws Exception {
    TransactionDAO dao = new TransactionDAO(session);
    Transaction trans = dao.findById(transactionId, false);
    trans.setState(TransactionConstants.WRONG_REQUEST);

    dao.makePersistent(trans);
    return trans;
  }

  public static RobotTransaction createRobotTransaction(Session session, User user, Integer skuId, String source)
      throws Exception {
    RobotTransactionDAO dao = new RobotTransactionDAO(session);
    RobotTransaction trans = new RobotTransaction();
    RobotSKUDAO robotSKUDAO = new RobotSKUDAO(session);
    RobotSKU sku = robotSKUDAO.findById(skuId.longValue());
    trans.setState(TransactionConstants.STATE_NEW);
    trans.setUser(user);
    trans.setRobotSKU(sku);
    trans.setSource(source);

    dao.makePersistent(trans);
    return trans;
  }

  public static Transaction createTransaction(Session session, User user, String successMessage, Long skuId,
      Object descripionObject, String source) throws Exception {
    SKU sku = (new SKUDAO(session)).findById(skuId);
    return createTransaction(session, user, successMessage != null ? successMessage : sku.getName(), sku,
        descripionObject, source);
  }

  public static Transaction createTransaction(Session session, User user, String successMessage, SKU sku,
      Object descripionObject, String source) throws Exception {
    TransactionDAO dao = new TransactionDAO(session);
    Transaction trans = new Transaction();
    trans.setState(TransactionConstants.STATE_NEW);
    trans.setUser(user);
    trans.setType(-1);
    trans.setSku(sku);
    trans.setSuccessMessage(successMessage);
    trans.setSource(source);

    if (descripionObject != null) {
      Serializer serializer = new Persister();
      StringWriter writer = new StringWriter();
      serializer.write(descripionObject, writer);
      trans.setDescription(writer.toString());
    }

    dao.makePersistent(trans);
    return trans;
  }

}
