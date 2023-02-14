package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Challenges;

public class ChallengesDAO extends DAO<Challenges> {

  public ChallengesDAO(Session session) {
    super(session);
  }
  
  public List<Challenges> findShowing() {
    //return findAll();
    //return findAllByParameter("active", true);
    return findAllByParameterValues("active", new Object[] { 0, 1, 2, 3 });
  }
  
  public Challenges findByType(String type) {
    return findByParameter("type", type);
  }

}
