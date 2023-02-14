package com.kavalok.cache;

import java.util.HashMap;
import java.util.Map;

import com.kavalok.db.Shop;

public class ShopCache {

  private Map<String, Shop> shopMap = new HashMap<String, Shop>();

  private static ShopCache instance = new ShopCache();

  public static ShopCache getInstance() {
    return instance;
  }

  public void clear() {
    shopMap.clear();
  }

  public Shop getShop(String name) {
    return shopMap.get(name);
  }

}
