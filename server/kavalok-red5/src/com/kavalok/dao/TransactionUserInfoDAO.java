package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.TransactionUserInfo;

public class TransactionUserInfoDAO extends DAO<TransactionUserInfo> {

  public TransactionUserInfoDAO(Session session) {
    super(session);
  }

  @SuppressWarnings("unchecked")
  public List<TransactionUserInfo> findByTransactionId(String transactionId) {
    return findAllByParameter("transactionId", transactionId);
  }
}
