package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.SkipWord;

public class SkipWordDAO extends WordDAO<SkipWord> {

  public SkipWordDAO(Session session) {
    super(session);
  }

}
