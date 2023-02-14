package com.kavalok.dto;

import com.kavalok.db.Challenges;

public class ChallengesTO {

  private int id;

  private String info;
  
  private int amountNeeded;

  private String charName;
  
  private int highestScore;
  
  private String type;
  
  private int active;

  public ChallengesTO(Challenges challenges) {
    super();
    id = challenges.getId().intValue();
    info = challenges.getInfo();
    amountNeeded = challenges.getAmountNeeded();
    charName  = challenges.getCharName();
    highestScore = challenges.getHighestScore();
    type = challenges.getType();
    active = challenges.getActive();
  }

  public ChallengesTO() {
    super();
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getInfo() {
    return info;
  }

  public void setInfo(String info) {
    this.info = info;
  }
  
  public int getAmountNeeded() {
    return amountNeeded;
  }

  public void setAmountNeeded(int amountNeeded) {
    this.amountNeeded = amountNeeded;
  }

  public String getCharName() {
    return charName;
  }

  public void setCharName(String charName) {
    this.charName = charName;
  }

  public int getHighestScore() {
    return highestScore;
  }

  public void setHighestScore(int highestScore) {
    this.highestScore = highestScore;
  }
  
  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }
  
  public int getActive() {
    return active;
  }

  public void setActive(int active) {
    this.active = active;
  }


}
