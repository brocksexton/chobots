package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.LotteryResult;

public class LotteryResultDAO extends DAO<LotteryResult> {

  public LotteryResultDAO(Session session) {
    super(session);
  }

  public LotteryResult findByLogin(String login) {
    return findByParameter("login", login);
  }

}
