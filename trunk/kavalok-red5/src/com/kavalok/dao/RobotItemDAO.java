package com.kavalok.dao;

import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Robot;
import com.kavalok.db.RobotItem;
import com.kavalok.db.User;

public class RobotItemDAO extends DAO<RobotItem> {

	public RobotItemDAO(Session session) {
		super(session);
	}
	
	@SuppressWarnings("unchecked")
	public List<RobotItem> findByUser(User user) {
		Criteria criteria = createItemCriteria();
		criteria.add(Restrictions.eq("user", user));
		return criteria.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<RobotItem> findByRobot(Robot robot) {
		Criteria criteria = createItemCriteria();
		criteria.add(Restrictions.eq("robot", robot));
		return criteria.list();
	}
	
	private Criteria createItemCriteria() {
		Criterion notExpiration = Restrictions.isNull("expirationDate");
		Criterion notExpired = Restrictions.gt("expirationDate", new Date());
		
		Criteria criteria = createCriteria();
		criteria.add(Restrictions.or(notExpiration, notExpired));
		criteria.add(Restrictions.ne("remains", 0));
		
		return criteria;
	}
	
}
