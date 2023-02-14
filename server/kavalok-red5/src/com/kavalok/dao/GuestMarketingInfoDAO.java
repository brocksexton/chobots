package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.GuestMarketingInfo;

public class GuestMarketingInfoDAO extends DAO<GuestMarketingInfo> {

  public GuestMarketingInfoDAO(Session session) {
    super(session);
  }

}
