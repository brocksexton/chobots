package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.LoginModelBase;

public class LoginDAOBase<T extends LoginModelBase> extends DAO<T> {

  public LoginDAOBase(Session session) {
    super(session);
  }

  public T findByLogin(String login, boolean deleted) {
    return findByParameters(new String[] { "login", "deleted" }, new Object[] { login, deleted });
  }

  public T findByLogin(String login) {
    return findByParameter("login", login);
  }
  
  public T findById(Long id) {
    return findByParameter("id", id);
  }



}
