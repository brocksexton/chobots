package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.MarketingInfo;

public class MarketingInfoDAO extends DAO<MarketingInfo> {

  public MarketingInfoDAO(Session session) {
    super(session);
  }

}
