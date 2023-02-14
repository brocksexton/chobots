package com.kavalok.dao.statistics;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.kavalok.dao.QueriesNames;
import com.kavalok.dao.common.DAO;
import com.kavalok.db.User;
import com.kavalok.db.UserExtraInfo;
import com.kavalok.db.statistics.LoginStatistics;

public class LoginStatisticsDAO extends DAO<LoginStatistics> {

  public LoginStatisticsDAO(Session session) {
    super(session);
  }

  public Object[] findForAll(Date minDate, Date maxDate) {
    Query query = getSession().getNamedQuery(QueriesNames.LOGIN_STATISTICS_SELECT_FOR_ALL);
    query.setParameter("minDate", minDate);
    query.setParameter("maxDate", maxDate);
    return (Object[]) query.uniqueResult();
  }

  public Integer getAverageTime(Date minDate, Date maxDate) {
    Query query = getSession().getNamedQuery(QueriesNames.LOGIN_STATISTICS_AVERAGE_SESSION_TIME);
    query.setParameter("minDate", minDate);
    query.setParameter("maxDate", maxDate);
    return query.uniqueResult() != null ? ((Double) query.uniqueResult()).intValue() : null;
  }

  public Integer getCount(Date minDate, Date maxDate) {
    Query query = getSession().createSQLQuery(
        "select count(*) from(" + "select * from LoginStatistics where logoutDate < :maxDate and loginDate > :minDate "
            + "group by user_id ) as result");
    // Query query =
    // getSession().getNamedQuery(QueriesNames.LOGIN_STATISTICS_COUNT_FOR_USERS);
    query.setParameter("minDate", minDate);
    query.setParameter("maxDate", maxDate);
    return ((BigInteger) query.uniqueResult()).intValue();
  }

  @SuppressWarnings("unchecked")
  public List<Object[]> findForUsers(Date minDate, Date maxDate, Integer firstResult, Integer maxResults) {
    Query query = getSession().getNamedQuery(QueriesNames.LOGIN_STATISTICS_SELECT_FOR_USERS);
    query.setParameter("minDate", minDate);
    query.setParameter("maxDate", maxDate);
    query.setFirstResult(firstResult);
    query.setMaxResults(maxResults);
    return query.list();
  }

  public Date getLastOnlineDate(User user) {
    UserExtraInfo uei = user.getUserExtraInfo();
    if (uei == null) {
      return null;
    }
    return uei.getLastLogoutDate();
  }
}
