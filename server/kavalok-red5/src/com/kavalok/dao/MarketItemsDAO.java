package com.kavalok.dao;

import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import com.kavalok.dao.common.DAO;
import com.kavalok.db.MarketItems;
import org.hibernate.criterion.Restrictions;
import java.util.Date;

public class MarketItemsDAO extends DAO<MarketItems> {

  public MarketItemsDAO(Session session) {
    super(session);
  }
  
  public List<MarketItems> findActive() {
    return findAllByParameter("active", true);
  }
  
  public List<MarketItems> findNext(int firstResult) {
	Order order = Order.asc("endDate");
    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(8);
    criteria.add(Restrictions.ge("endDate", new Date()));
	criteria.add(Restrictions.eq("active", true));
	criteria.addOrder(order);
    return criteria.list();
  }
  
  public MarketItems findById(Integer id) {
    return findByParameter("id", id);
  }
  
  public List<MarketItems> findByCreatorId(Integer creatorId, int firstResult) {
	Order order = Order.asc("endDate");
    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(8);
	criteria.add(Restrictions.eq("active", true));
	criteria.add(Restrictions.eq("createdBy", creatorId));
	/*if(orderBy == "endingsoonest") {
		Order order = Order.asc("endDate");
		criteria.addOrder(order);
	} else if(orderBy == "mostrecent") {
		Order order = Order.asc("created");
		criteria.addOrder(order);
	} else if(orderBy == "oldest") {
		Order order = Order.desc("created");
		criteria.addOrder(order);
	} else if(orderBy == "leastExpensive") {
		Order order = Order.asc("currentBid");
		criteria.addOrder(order);
	} else if(orderBy == "mostExpensive") {
		Order order = Order.desc("currentBid");
		criteria.addOrder(order);
	} else if(orderBy == "fewestBids") {
		Order order = Order.asc("bidNumber");
		criteria.addOrder(order);
	} else if(orderBy == "mostBids") {
		Order order = Order.desc("bidNumber");
		criteria.addOrder(order);
	}
	*/
	criteria.addOrder(order);
    return criteria.list();
  }
  
  public List<MarketItems> findByBuyerId(Integer buyerId, int firstResult) {
	Order order = Order.asc("endDate");
    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(8);
	criteria.add(Restrictions.eq("active", true));
	criteria.add(Restrictions.eq("buyerId", buyerId));
	criteria.addOrder(order);
    return criteria.list();
  }

}
