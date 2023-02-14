package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.MarketLogs;

public class MarketLogsDAO extends DAO<MarketLogs> {

  public MarketLogsDAO(Session session) {
    super(session);
  }

 

}
