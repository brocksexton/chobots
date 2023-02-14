package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Robot;
import com.kavalok.db.User;

public class RobotDAO extends DAO<Robot> {

	public RobotDAO(Session session) {
		super(session);
	}
	
	public List<Robot> findByUser(User user) {
		return findAllByParameter("user", user);
	}
	
	@SuppressWarnings("unchecked")
	public List<Robot> getScoreTable(Integer topCount) {
		Criteria criteria = createCriteria();
		criteria.addOrder(Order.desc("experience"));
		criteria.setMaxResults(topCount);
		List<Robot> result = (List<Robot>) criteria.list(); 
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public Robot getActiveRobot(User user) {
		Criteria criteria = createCriteria();
		criteria.add(Restrictions.eq("user", user));
		criteria.add(Restrictions.eq("active", true));
		
		List<Robot> result = criteria.list();
		return (result.size() > 0)
			? result.get(0)
			: null;
	}
	
	public Boolean robotExists(User user) {
		Criteria criteria = createCriteria();
		criteria.add(Restrictions.eq("user", user));
		criteria.setMaxResults(1);
		return criteria.list().size() > 0;
	}
}
