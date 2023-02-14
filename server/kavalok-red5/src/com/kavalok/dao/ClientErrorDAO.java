package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.ClientError;

public class ClientErrorDAO extends DAO<ClientError> {

  public ClientErrorDAO(Session session) {
    super(session);
  }

  public ClientError findError(String message) {
    return findByParameter("message", message);
  }

  @SuppressWarnings("unchecked")
  public List<ClientError> findErrors(int firstResult, int maxResults) {
    Order order = Order.desc("updated");

    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    criteria.addOrder(order);
    return criteria.list();
  }

}
