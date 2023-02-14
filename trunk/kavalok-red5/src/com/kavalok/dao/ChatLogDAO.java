package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.ChatLog;

public class ChatLogDAO extends DAO<ChatLog> {

  public ChatLogDAO(Session session) {
    super(session);
  }

 

}
