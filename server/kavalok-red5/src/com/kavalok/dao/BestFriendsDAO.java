package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.BestFriends;

public class BestFriendsDAO extends DAO<BestFriends> {

  public BestFriendsDAO(Session session) {
    super(session);
  }

  public BestFriends findError(String action) {
    return findByParameter("action", action);
  }

    public List<BestFriends> findWhoToSend(Long userId) {
  return findAllByParameter("userId", userId);
  }

 public BestFriends findPreciseFriend(Long theirId, Long myId) {
    return findByParameters(new String[] { "userId", "friendId" }, new Object[] { theirId, myId });
  }
  @SuppressWarnings("unchecked")
  public List<BestFriends> findErrors(int firstResult, int maxResults) {
    Order order = Order.desc("updated");

    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    criteria.addOrder(order);
    return criteria.list();
  }

}
