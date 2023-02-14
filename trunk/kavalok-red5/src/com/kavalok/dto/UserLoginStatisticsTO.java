package com.kavalok.dto;

public class UserLoginStatisticsTO extends LoginStatisticsTO {
  private String userEmail;

  public UserLoginStatisticsTO(String userEmail, Long secondsInGame, Integer loginCount) {
    super(secondsInGame, loginCount);
    this.userEmail = userEmail;
  }

  public String getUserEmail() {
    return userEmail;
  }

  public void setUserEmail(String userEmail) {
    this.userEmail = userEmail;
  }

}
