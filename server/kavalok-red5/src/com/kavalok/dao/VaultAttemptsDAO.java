package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.VaultAttempts;

public class VaultAttemptsDAO extends DAO<VaultAttempts> {

  public VaultAttemptsDAO(Session session) {
    super(session);
  }

  public VaultAttempts findByUID(Long user_id) {
    return findByParameter("user_id", user_id);
  }

}
