package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.UserExtraInfo;

public class UserExtraInfoDAO extends DAO<UserExtraInfo> {

  public UserExtraInfoDAO(Session session) {
    super(session);
  }

}
