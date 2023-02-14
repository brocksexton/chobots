package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.EmailExtraInfo;

public class EmailExtraInfoDAO extends DAO<EmailExtraInfo> {

  public EmailExtraInfoDAO(Session session) {
    super(session);
  }

  public EmailExtraInfo findByEmail(String email) {
    return findByParameter("email", email);
  }

}
