package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.LogicalExpression;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Quest;
import com.kavalok.db.Server;

public class QuestDAO extends DAO<Quest> {

	public QuestDAO(Session session) {
		super(session);
	}

	@SuppressWarnings("unchecked")
	public List<Object> findEnabled(Server server) {
		Criteria criteria = createCriteria();
		criteria.setProjection(Projections.property("name"));
		criteria.add(Restrictions.eq("enabled", true));
		LogicalExpression serverRestriction = Restrictions.or(
				Restrictions.eq("server", server), Restrictions.isNull("server"));
		criteria.add(serverRestriction);

		return criteria.list();
	}

}
