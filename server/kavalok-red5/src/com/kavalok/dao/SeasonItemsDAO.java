package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.SeasonItems;
import org.hibernate.criterion.Restrictions;
import org.hibernate.Criteria;

public class SeasonItemsDAO extends DAO<SeasonItems> {

  public SeasonItemsDAO(Session session) {
    super(session);
  }
  
  public List<SeasonItems> findEnabled() {
    return findAllByParameter("enabled", true);
  }
  
  public List<SeasonItems> findReward(Integer tier) {
	return findAllByParameters(new String[] { "tier", "active" }, new Object[] { tier, true });
  }
  
  public List<SeasonItems> findByPage(Integer page) {
    Criteria criteria = createCriteria();
	criteria.add(Restrictions.eq("active", true));
	criteria.add(Restrictions.in("tier",  new Object[] { page, page+1,page+2,page+3,page+4 }));
	criteria.setMaxResults(12);
    return criteria.list();
  }

}