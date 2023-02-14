package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.TopScore;

public class TopScoreDAO extends DAO<TopScore> {

  public TopScoreDAO(Session session) {
    super(session);
    // TODO Auto-generated constructor stub
  }

  public TopScore findScore(GameChar gameChar, String scoreId) {
    String[] names = { "gameChar", "scoreId" };
    Object[] values = { gameChar, scoreId };

    return findByParameters(names, values);
  }

  public void setScore(GameChar gameChar, String scoreId, double score) {
    TopScore topScore = findScore(gameChar, scoreId);

    if (topScore == null) {
      topScore = new TopScore();
      topScore.setGameChar(gameChar);
      topScore.setScoreId(scoreId);
    }

    if (score > topScore.getScore())
      topScore.setScore(score);

    makePersistent(topScore);
  }

  @SuppressWarnings("unchecked")
  public List<TopScore> getScoreTable(String scoreId, Integer topCount) {
    String[] names = { "scoreId" };
    Object[] values = { scoreId };
    Order order = Order.desc("score");

    Criteria criteria = createCriteria(names, values, order);
    criteria.setMaxResults(topCount);
    return criteria.list();
  }

}
