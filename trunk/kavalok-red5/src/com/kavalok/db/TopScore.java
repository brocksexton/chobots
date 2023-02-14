package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class TopScore extends ModelBase {
  private GameChar gameChar;

  private String scoreId;

  private double score;

  public TopScore() {
    super();
    // TODO Auto-generated constructor stub
  }

  @NotNull
  @ManyToOne(fetch=FetchType.LAZY)
  public GameChar getGameChar() {
    return gameChar;
  }

  public void setGameChar(GameChar gameChar) {
    this.gameChar = gameChar;
  }

  @NotNull
  public String getScoreId() {
    return scoreId;
  }

  public void setScoreId(String scoreId) {
    this.scoreId = scoreId;
  }

  @NotNull
  public double getScore() {
    return score;
  }

  public void setScore(double score) {
    this.score = score;
  }
}
