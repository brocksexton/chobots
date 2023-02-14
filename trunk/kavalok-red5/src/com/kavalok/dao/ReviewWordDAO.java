package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.ReviewWord;

public class ReviewWordDAO extends WordDAO<ReviewWord> {

  public ReviewWordDAO(Session session) {
    super(session);
  }

}
