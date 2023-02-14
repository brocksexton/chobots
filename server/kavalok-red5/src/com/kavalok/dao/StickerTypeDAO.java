package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.StickerType;

public class StickerTypeDAO extends DAO<StickerType> {

  public StickerTypeDAO(Session session) {
    super(session);
  }

  public List<StickerType> findEnabled() {
    return findAllByParameter("enabled", true);
  }

}
