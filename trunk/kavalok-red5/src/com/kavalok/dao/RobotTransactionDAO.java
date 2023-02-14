package com.kavalok.dao;

import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.RobotTransaction;

public class RobotTransactionDAO extends DAO<RobotTransaction> {

  public RobotTransactionDAO(Session session) {
    super(session);
  }

  @SuppressWarnings("unchecked")
  public List<Object[]> findForDates(Long partnerId, Date minDate, Date maxDate) {
    if (partnerId != null) {
      Query query = getSession().getNamedQuery(QueriesNames.ROBOT_TRANSACTION_STATISTICS_SELECT_PROCESSED_PARTNER);
      query.setParameter("partnerId", partnerId);
      query.setParameter("minDate", minDate);
      query.setParameter("maxDate", maxDate);
      return query.list();
    } else {
      Query query = getSession().getNamedQuery(QueriesNames.ROBOT_TRANSACTION_STATISTICS_SELECT_PROCESSED);
      query.setParameter("minDate", minDate);
      query.setParameter("maxDate", maxDate);
      return query.list();
    }
  }

}
