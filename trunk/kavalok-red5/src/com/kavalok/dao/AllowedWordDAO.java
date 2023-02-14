package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.AllowedWord;

public class AllowedWordDAO extends WordDAO<AllowedWord> {

  public AllowedWordDAO(Session session) {
    super(session);
  }

}
