package com.kavalok.dto;


public class UserReportTO {

  private Integer userId;

  private String login;

  private Integer reportsCount;

  private String text;


  public UserReportTO(Integer userId, String login, Integer reportsCount, String text) {
    super();
    this.userId = userId;
    this.login = login;
    this.reportsCount = reportsCount;
    this.text = text;
  }

  public Integer getUserId() {
    return userId;
  }

  public void setUserId(Integer userId) {
    this.userId = userId;
  }

  public Integer getReportsCount() {
    return reportsCount;
  }

  public void setReportsCount(Integer reportsCount) {
    this.reportsCount = reportsCount;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String user) {
    this.login = user;
  }

  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }


}
