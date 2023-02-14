package com.kavalok.transactions;

import org.hibernate.Session;

public interface ISessionDependent {
  void setSession(Session session);
}
