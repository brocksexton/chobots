package com.kavalok.dto;

public class MoneyEarnedTO {

  private String userEmail;

  private Integer moneyEarned;

  public MoneyEarnedTO(String userEmail, Integer moneyEarned) {
    super();
    this.userEmail = userEmail;
    this.moneyEarned = moneyEarned;
  }

  public String getUserEmail() {
    return userEmail;
  }

  public void setUserEmail(String userEmail) {
    this.userEmail = userEmail;
  }

  public Integer getMoneyEarned() {
    return moneyEarned;
  }

  public void setMoneyEarned(Integer moneyEarned) {
    this.moneyEarned = moneyEarned;
  }

}
