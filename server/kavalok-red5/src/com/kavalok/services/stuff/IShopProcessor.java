package com.kavalok.services.stuff;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dto.stuff.StuffTypeTO;

public interface IShopProcessor {
  public List<StuffTypeTO> getStuffTypes(Session session, String shopName);

  public Integer getStuffTypesCount(Session session, String shopName);
}
