package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.RobotType;

public class RobotTypeDAO extends DAO<RobotType> {

	public RobotTypeDAO(Session session) {
		super(session);
	}
	
	@SuppressWarnings("unchecked")
	public List<RobotType> findByCatalog(String catalog) {
		
		Criteria criteria = createCriteria();
		criteria.add(Restrictions.eq("catalog", catalog));
		criteria.addOrder(Order.asc("level"));
		criteria.addOrder(Order.asc("placement"));
		
		return criteria.list();
	}
	
}
