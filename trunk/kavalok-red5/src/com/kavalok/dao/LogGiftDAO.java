package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.LogGift;

public class LogGiftDAO extends DAO<LogGift> {

  public LogGiftDAO(Session session) {
    super(session);
  }

  public LogGift findError(String action) {
    return findByParameter("action", action);
  }

  @SuppressWarnings("unchecked")
  public List<LogGift> findErrors(int firstResult, int maxResults) {
    Order order = Order.desc("updated");

    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    criteria.addOrder(order);
    return criteria.list();
  }

}
