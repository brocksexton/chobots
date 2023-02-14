package com.kavalok.transactions;

import org.hibernate.Session;

import com.kavalok.utils.HibernateUtil;

public class DefaultNonTransactionStrategy implements ITransactionStrategy {

  private Session session;

  public Session getSession() {
    return session;
  }

  @Override
  public void afterCall() {
    if (session.isOpen()) {
      session.flush();
      session.close();
    }
  }

  @Override
  public void beforeCall() {
    session = HibernateUtil.getSessionFactory().openSession();
  }

  @Override
  public void afterError(Throwable e) {
    session.close();
  }

}
