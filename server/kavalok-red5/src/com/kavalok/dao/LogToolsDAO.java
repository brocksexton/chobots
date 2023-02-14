package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.LogTools;

public class LogToolsDAO extends DAO<LogTools> {

  public LogToolsDAO(Session session) {
    super(session);
  }

  public LogTools findError(String action) {
    return findByParameter("action", action);
  }

  @SuppressWarnings("unchecked")
  public List<LogTools> findErrors(int firstResult, int maxResults) {
    Order order = Order.desc("updated");

    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    criteria.addOrder(order);
    return criteria.list();
  }

}
