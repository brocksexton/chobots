package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.PaperMessage;

public class PaperMessageDAO extends DAO<PaperMessage> {

  public PaperMessageDAO(Session session) {
    super(session);
  }

  public List<PaperMessage> findLast(Integer maxResults) {
    Integer size = size();
    if (size < maxResults) {
      return findAll();
    } else {
      return findAll(size - maxResults, maxResults);
    }

  }
}
