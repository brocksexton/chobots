package com.kavalok.dto;

public class ServerConfigTO {
  private Boolean guestsEnabled;

  private Boolean registrationEnabled;

  private Boolean adyenEnabled;

  private Integer spamMessagesLimit;

  private Integer serverLimit;

  private Integer gameVersion;

  private String dailyReward;

  public ServerConfigTO() {
    super();
  }

  public ServerConfigTO(Boolean guestsEnabled, Boolean registrationEnabled, Boolean adyenEnabled,
      Integer spamMessagesLimit, Integer serverLimit, Integer gameVersion, String dailyReward) {
    super();
    this.guestsEnabled = guestsEnabled;
    this.registrationEnabled = registrationEnabled;
    this.adyenEnabled = adyenEnabled;
    this.spamMessagesLimit = spamMessagesLimit;
    this.serverLimit = serverLimit;
    this.gameVersion = gameVersion;
    this.dailyReward = dailyReward;

  }

  public Boolean getGuestsEnabled() {
    return guestsEnabled;
  }

  public void setGuestsEnabled(Boolean guestsEnabled) {
    this.guestsEnabled = guestsEnabled;
  }

  public Boolean getRegistrationEnabled() {
    return registrationEnabled;
  }

  public void setRegistrationEnabled(Boolean registrationEnabled) {
    this.registrationEnabled = registrationEnabled;
  }

  public Boolean getAdyenEnabled() {
    return adyenEnabled;
  }

  public void setAdyenEnabled(Boolean adyenEnabled) {
    this.adyenEnabled = adyenEnabled;
  }

  public Integer getSpamMessagesLimit() {
    return spamMessagesLimit;
  }

  public void setSpamMessagesLimit(Integer spamMessagesLimit) {
    this.spamMessagesLimit = spamMessagesLimit;
  }

  public Integer getServerLimit() {
    return serverLimit;
  }

  public void setServerLimit(Integer serverLimit) {
    this.serverLimit = serverLimit;
  }

  public Integer getGameVersion() {
    return gameVersion;
  }

  public void setGameVersion(Integer gameVersion) {
    this.gameVersion = gameVersion;
  }


  public String getDailyReward() {
    return dailyReward;
  }

  public void setDailyReward(String dailyReward) {
    this.dailyReward = dailyReward;
  }

}
