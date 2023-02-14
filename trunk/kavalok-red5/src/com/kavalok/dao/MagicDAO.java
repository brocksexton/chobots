package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.MagicPanel;

public class MagicDAO extends LoginDAOBase<MagicPanel> {

  public MagicDAO(Session session) {
    super(session);
  }

}
