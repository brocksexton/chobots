package com.kavalok.dto;

import com.kavalok.db.SeasonItems;

public class SeasonItemsTO {

  private int id;
  private int season;
  private int tier;
  private int slot;
  private String rewardType;
  private String reward;
  private boolean active;

  public SeasonItemsTO(SeasonItems seasonItems) {
    super();
    id = seasonItems.getId().intValue();
    season = seasonItems.getSeason();
    tier = seasonItems.getTier();
    slot = seasonItems.getSlot();
    rewardType = seasonItems.getRewardType();
    reward  = seasonItems.getReward();
    active = seasonItems.isActive();
  }

  public SeasonItemsTO() {
    super();
  }

  public int getId() {
    return id;
  }
  
  public void setId(int id) {
    this.id = id;
  }
  
  public int getSeason() {
    return season;
  }
  
  public void setSeason(int season) {
    this.season = season;
  }
  
  public int getTier() {
    return tier;
  }
  
  public void setTier(int tier) {
    this.tier = tier;
  }
  
  public int getSlot() {
    return slot;
  }
  
  public void setSlot(int slot) {
    this.slot = slot;
  }
  
  public String getRewardType() {
    return rewardType;
  }

  public void setRewardType(String rewardType) {
    this.rewardType = rewardType;
  }
  
  public String getReward() {
    return reward;
  }

  public void setReward(String reward) {
    this.reward = reward;
  }
  
  public boolean isActive() {
    return active;
  }

  public void setActive(boolean active) {
    this.active = active;
  }


}
