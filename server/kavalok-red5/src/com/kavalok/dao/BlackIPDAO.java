package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.BlackIP;

public class BlackIPDAO extends DAO<BlackIP> {

  public BlackIPDAO(Session session) {
    super(session);
    // TODO Auto-generated constructor stub
  }

  public BlackIP findByIp(String ip) {
    return findByParameter("ip", ip);
  }

}
