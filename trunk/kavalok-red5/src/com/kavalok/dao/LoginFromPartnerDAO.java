package com.kavalok.dao;

import java.util.Iterator;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.LoginFromPartner;
import com.kavalok.db.User;

public class LoginFromPartnerDAO extends DAO<LoginFromPartner> {

  public LoginFromPartnerDAO(Session session) {
    super(session);
  }

  public LoginFromPartner findByUser(User user) {
    return findByParameter("user", user);
  }

  public void cleanUp(User user) {
    for (Iterator<LoginFromPartner> iterator = findAllByParameter("user", user).iterator(); iterator.hasNext();) {
      LoginFromPartner item = iterator.next();
      makeTransient(item);
    }
  }

  public LoginFromPartner findByUid(String uid) {
    return findByParameter("uid", uid);
  }

}
