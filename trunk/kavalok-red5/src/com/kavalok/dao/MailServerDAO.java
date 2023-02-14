package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.MailServer;

public class MailServerDAO extends DAO<MailServer> {

  public MailServerDAO(Session session) {
    super(session);
  }

  public List<MailServer> findAvailable() {
    return findAllByParameter("available", true);
  }

}
