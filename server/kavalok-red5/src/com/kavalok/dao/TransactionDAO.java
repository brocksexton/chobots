package com.kavalok.dao;

import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Transaction;

public class TransactionDAO extends DAO<Transaction> {

  public TransactionDAO(Session session) {
    super(session);
  }

  @SuppressWarnings("unchecked")
  public List<Object[]> findForDates(Long partnerId, Date minDate, Date maxDate) {
    if (partnerId != null) {
      Query query = getSession().getNamedQuery(QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED_PARTNER);
      query.setParameter("partnerId", partnerId);
      query.setParameter("minDate", minDate);
      query.setParameter("maxDate", maxDate);
      return query.list();
    } else {
      Query query = getSession().getNamedQuery(QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED);
      query.setParameter("minDate", minDate);
      query.setParameter("maxDate", maxDate);
      return query.list();
    }
  }
  
  @SuppressWarnings("unchecked")
  public List<Object[]> findForDatesOld(Long partnerId, Date minDate, Date maxDate) {
    if (partnerId != null) {
      Query query = getSession().getNamedQuery(QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED_PARTNER_OLD);
      query.setParameter("partnerId", partnerId);
      query.setParameter("minDate", minDate);
      query.setParameter("maxDate", maxDate);
      return query.list();
    } else {
      Query query = getSession().getNamedQuery(QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED_OLD);
      query.setParameter("minDate", minDate);
      query.setParameter("maxDate", maxDate);
      return query.list();
    }
  }

}
