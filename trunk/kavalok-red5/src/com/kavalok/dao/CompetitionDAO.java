package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Competition;

public class CompetitionDAO extends DAO<Competition> {

  public CompetitionDAO(Session session) {
    super(session);
  }
  
  public Competition findByName(String name)
  {
    return findByParameter("name", name);
  }

}
