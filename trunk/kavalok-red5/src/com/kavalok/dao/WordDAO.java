package com.kavalok.dao;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.dto.PagedResult;

public abstract class WordDAO<T> extends DAO<T> {

  public WordDAO(Session session) {
    super(session);
  }

  @Override
  protected Criteria createCriteria() {
    Criteria criteria = super.createCriteria();
    criteria.addOrder(Order.asc("word"));
    return criteria;
  }

  public boolean hasWord(String word) {
    return findByParameter("word", word) != null;
  }

  @SuppressWarnings("unchecked")
  public PagedResult<T> findLikeWord(String word, Integer firstResult, Integer maxResults) {
    Criteria criteria = createCriteria();
    criteria.add(Restrictions.like("word", word));
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    
    Criteria sizeCriteria = createCriteria();
    sizeCriteria.add(Restrictions.like("word", word));
    sizeCriteria.setProjection(Projections.rowCount());
    
    return new PagedResult<T>((Integer) sizeCriteria.uniqueResult(), criteria.list());
  }

  public T findByWord(String word) {
    return findByParameter("word", word);
  }

}
