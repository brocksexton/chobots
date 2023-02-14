package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.AdminMessage;

public class AdminMessageDAO extends DAO<AdminMessage> {

  public AdminMessageDAO(Session session) {
    super(session);
  }

  public List<AdminMessage> findNotProcessed() {
    return findAllByParameter("processed", false);
  }

  @SuppressWarnings("unchecked")
  public List<AdminMessage> findNotProcessed(int firstResult, int maxResults) {
    Criteria criteria = createCriteria();
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    criteria.add(Restrictions.eq("processed", false));
    return criteria.list();
  }
}
