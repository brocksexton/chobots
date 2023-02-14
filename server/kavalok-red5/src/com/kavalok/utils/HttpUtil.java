package com.kavalok.utils;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class HttpUtil {
  @SuppressWarnings("unchecked")
  public static Map<String, String> normalizeRequestParameteres(Map params) {
    Map newMap = new HashMap();
    for (Iterator iterator = params.entrySet().iterator(); iterator
        .hasNext();) {
      Map.Entry entry = (Map.Entry) iterator.next();
      if (entry.getValue() instanceof String[]) {
        String[] paramValue = (String[]) entry.getValue();
        if (paramValue.length > 0) {
          newMap.put(entry.getKey(), paramValue[0]);
        }

      }
    }
    return newMap;
  }

}
