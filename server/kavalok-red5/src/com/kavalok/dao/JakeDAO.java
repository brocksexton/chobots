package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.Jake;

public class JakeDAO extends LoginDAOBase<Jake> {

  public JakeDAO(Session session) {
    super(session);
  }

}
