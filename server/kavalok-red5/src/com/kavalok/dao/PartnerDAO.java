package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.db.Partner;

public class PartnerDAO extends LoginDAOBase<Partner> {

  public PartnerDAO(Session session) {
    super(session);
  }

}
