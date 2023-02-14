package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Ban;
import com.kavalok.db.User;
import com.kavalok.dto.CharTOCache;

public class BanDAO extends DAO<Ban> {

  public BanDAO(Session session) {
    super(session);
    // TODO Auto-generated constructor stub
  }

  public Ban findByUser(User user) {
    return findByParameter("user", user);
  }
  
  @Override
  public Ban makePersistent(Ban entity) {
    CharTOCache.getInstance().removeCharTO(entity.getUser().getId());
    CharTOCache.getInstance().removeCharTO(entity.getUser().getLogin());
    return super.makePersistent(entity);
  }

}
