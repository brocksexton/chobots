package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.MembershipInfo;

public class MembershipInfoDAO extends DAO<MembershipInfo> {

  public MembershipInfoDAO(Session session) {
    super(session);
  }

}
