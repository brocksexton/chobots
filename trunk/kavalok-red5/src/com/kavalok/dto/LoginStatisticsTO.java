package com.kavalok.dto;

public class LoginStatisticsTO {
  private Long secondsInGame;

  private Integer averageTime;

  
  private Integer loginCount;


  public LoginStatisticsTO(Long secondsInGame, Integer loginCount) {
    super();
    this.secondsInGame = secondsInGame;
    this.loginCount = loginCount;
  }

  public LoginStatisticsTO(Long secondsInGame, Integer averageTime, Integer loginCount) {
    super();
    this.secondsInGame = secondsInGame;
    this.averageTime = averageTime;
    this.loginCount = loginCount;
  }


  public Long getSecondsInGame() {
    return secondsInGame;
  }

  public void setSecondsInGame(Long secondsInGame) {
    this.secondsInGame = secondsInGame;
  }

  public Integer getLoginCount() {
    return loginCount;
  }

  public void setLoginCount(Integer loginCount) {
    this.loginCount = loginCount;
  }

  public Integer getAverageTime() {
    return averageTime;
  }

  public void setAverageTime(Integer averageTime) {
    this.averageTime = averageTime;
  }


}
