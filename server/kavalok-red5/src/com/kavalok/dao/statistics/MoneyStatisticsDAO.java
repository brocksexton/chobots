package com.kavalok.dao.statistics;

import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.kavalok.dao.QueriesNames;
import com.kavalok.dao.common.DAO;
import com.kavalok.db.statistics.MoneyStatistics;

public class MoneyStatisticsDAO extends DAO<MoneyStatistics> {

  public MoneyStatisticsDAO(Session session) {
    super(session);
  }

  public Integer getCount(Date minDate, Date maxDate) {
    Query query = getSession().getNamedQuery(QueriesNames.MONEY_STATISTICS_SELECT_COUNT);
    query.setParameter("minDate", minDate);
    query.setParameter("maxDate", maxDate);
    return (Integer) query.uniqueResult();
  }

  @SuppressWarnings("unchecked")
  public List<Object[]> find(Date minDate, Date maxDate, Integer firstResult, Integer maxResults) {
    Query query = getSession().getNamedQuery(QueriesNames.MONEY_STATISTICS_SELECT_FOR_USERS);
    query.setParameter("minDate", minDate);
    query.setParameter("maxDate", maxDate);
    query.setFirstResult(firstResult);
    query.setMaxResults(maxResults);
    return query.list();
  }

}
