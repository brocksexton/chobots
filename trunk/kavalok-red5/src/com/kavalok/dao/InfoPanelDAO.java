package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.InfoPanel;

public class InfoPanelDAO extends DAO<InfoPanel> {

  public InfoPanelDAO(Session session) {
    super(session);
  }
  
  public InfoPanel findInfo(Long infoId) {
	  return findByParameter("id", infoId);
  }
  
  @SuppressWarnings("unchecked")
  public List<InfoPanel> getAvailableList() {
	  Criteria criteria = createCriteria();
	  criteria.add(Restrictions.eq("enabled", true));
	  criteria.addOrder(Order.desc("created"));
	  return criteria.list();
  }

}
