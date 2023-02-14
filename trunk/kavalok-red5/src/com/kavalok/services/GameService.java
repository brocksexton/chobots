package com.kavalok.services;

import java.util.ArrayList;
import java.util.List;

import org.red5.io.utils.ObjectMap;

import com.kavalok.dao.TopScoreDAO;
import com.kavalok.db.TopScore;
import com.kavalok.services.common.DataServiceNotTransactionBase;

public class GameService extends DataServiceNotTransactionBase {

  public List<ObjectMap<String, Object>> getScore(String scoreId, Integer topCount) {
    List<TopScore> scores = new TopScoreDAO(getSession()).getScoreTable(scoreId, topCount);

    List<ObjectMap<String, Object>> result = new ArrayList<ObjectMap<String, Object>>();

    for (TopScore topScore : scores) {
      ObjectMap<String, Object> item = new ObjectMap<String, Object>();
      item.put("name", topScore.getGameChar().getLogin());
      item.put("score", topScore.getScore());
      result.add(item);
    }

    return result;
  }

}
