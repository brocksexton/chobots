package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Vault;

public class VaultDAO extends DAO<Vault> {

  public VaultDAO(Session session) {
    super(session);
  }
  
  public List<Vault> findEnabled() {
    return findAllByParameter("enabled", true);
  }
  
  public Vault findByCode(Integer code) {
	return findByParameters(new String[] { "code", "enabled" }, new Object[] { code, true });
  }

}