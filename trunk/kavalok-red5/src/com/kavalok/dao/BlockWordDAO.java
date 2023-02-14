package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.BlockWord;

public class BlockWordDAO extends WordDAO<BlockWord> {

  public BlockWordDAO(Session session) {
    super(session);
  }

}
