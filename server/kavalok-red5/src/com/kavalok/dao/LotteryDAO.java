package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Lottery;

public class LotteryDAO extends DAO<Lottery> {

  public LotteryDAO(Session session) {
    super(session);
  }

  public List<Lottery> findEnabled() {
    return findAllByParameter("enabled", true);
  }

}
