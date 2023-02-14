package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Anim;

public class AnimDAO extends DAO<Anim> {

  public AnimDAO(Session session) {
    super(session);
  }

 /* public List<Server> findAvailable() {
    return findAllByParameters(new String[] { "available", "running" }, new Object[] { true, true });
  }
*/
  public List<Anim> findEnabled() {
    return findAllByParameter("enabled", true);
  }

  public Anim findByName(String name) {
    return findByParameter("name", name);
  }

  public Anim findByUrl(String url) {
    return findByParameter("url", url);
  }

}
