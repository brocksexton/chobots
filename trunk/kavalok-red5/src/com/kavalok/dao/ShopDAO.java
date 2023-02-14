package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Shop;

public class ShopDAO extends DAO<Shop> {

  public ShopDAO(Session session) {
    super(session);
  }

  public Shop findByName(String name) {
    return findByParameter("name", name);
  }
}
