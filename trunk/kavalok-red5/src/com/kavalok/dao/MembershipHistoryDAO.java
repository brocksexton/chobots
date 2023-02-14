package com.kavalok.dao;

import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.MembershipHistory;

public class MembershipHistoryDAO extends DAO<MembershipHistory> {

	public MembershipHistoryDAO(Session session) {
		super(session);
	}

	@SuppressWarnings("unchecked")
	public List<Object[]> countByUserAge(Date from, Date to, Integer periodSeconds) {
		Query query = getSession().getNamedQuery(
				QueriesNames.STATISTICS_SELECT_MEMBERS_AGE);
		query.setDate("from", from);
		query.setDate("to", to);
		query.setInteger("period", periodSeconds);
		return query.list();
	}

	@SuppressWarnings("unchecked")
	public List<MembershipHistory> findByEndDate(Date endDate) {
		Criteria criteria = createCriteria();
		criteria.add(Restrictions.eq("endDate", endDate));
		criteria.addOrder(Order.desc("endDate"));
		return criteria.list();
	}

}
