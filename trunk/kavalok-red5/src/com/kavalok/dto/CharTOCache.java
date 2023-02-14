package com.kavalok.dto;

import java.util.HashMap;
import java.util.Map;

public class CharTOCache {

  private static CharTOCache instance = new CharTOCache();

  private Map<Object, CharTO> cache = new HashMap<Object, CharTO>();

  private CharTOCache() {
  };

  public static CharTOCache getInstance() {
    return instance;
  }

  public CharTO getCharTO(Object idOrLogin) {
    return cache.get(idOrLogin);
  }

  public void putCharTO(CharTO to) {
    cache.put(to.getUserId().longValue(), to);
    cache.put(to.getLogin(), to);
  }

  public void removeCharTO(Object idOrLogin) {
    cache.remove(idOrLogin);
  }
}
