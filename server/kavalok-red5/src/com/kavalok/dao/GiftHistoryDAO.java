package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.GiftHistory;

public class GiftHistoryDAO extends DAO<GiftHistory> {

  public GiftHistoryDAO(Session session) {
    super(session);
  }

  public GiftHistory findError(String from) {
    return findByParameter("from", from);
  }

  @SuppressWarnings("unchecked")
  public List<GiftHistory> findErrors(int firstResult, int maxResults) {
    Order order = Order.desc("ip");

    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    criteria.addOrder(order);
    return criteria.list();
  }

}
