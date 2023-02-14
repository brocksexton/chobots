package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.Message;

public class MessageDAO extends DAO<Message> {

  public MessageDAO(Session session) {
    super(session);
    // TODO Auto-generated constructor stub
  }

  @SuppressWarnings("unchecked")
  public List<Message> getMessages(GameChar gameChar, int firstResult) {
    Criteria criteria = createGameCharCriteria(gameChar);
    criteria.setFirstResult(firstResult);
    return criteria.list();
  }
  @SuppressWarnings("unchecked")
  public List<Message> getMessages(GameChar gameChar) {
    Criteria criteria = createGameCharCriteria(gameChar);

    return criteria.list();
  }

  private Criteria createGameCharCriteria(GameChar gameChar) {
    String[] names = { "recipient" };
    Object[] values = { gameChar };
    Order order = Order.asc("dateTime");

    Criteria criteria = createCriteria(names, values, order);
    return criteria;
  }

}
