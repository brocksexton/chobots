package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Tokens;

public class TokensDAO extends DAO<Tokens> {

  public TokensDAO(Session session) {
    super(session);
  }

  public List<Tokens> findEnabled() {
    return findAllByParameter("available", true);
  }

  public Tokens findByCode(String code) {
    return findByParameter("code", code);
  }

}
