package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Stickers;

public class StickersDAO extends DAO<Stickers> {

  public StickersDAO(Session session) {
    super(session);
  }

  public Stickers findByLogin(String login) {
    return findByParameter("login", login);
  }

    public List<Stickers> findByUser(Long userId) {
    return findAllByParameter("user_id", userId);
  }

}
