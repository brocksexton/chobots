package com.kavalok.dto.login;


public class PartnerLoginCredentialsTO {

  private String login;
  private String password;
  private Boolean needRegistartion;
  private Integer userId;
  
  
  public PartnerLoginCredentialsTO(Integer userId, String login, String password, Boolean needRegistartion) {
    super();
    this.userId = userId;
    this.login = login;
    this.password = password;
    this.needRegistartion = needRegistartion;
  }
  public String getLogin() {
    return login;
  }
  public void setLogin(String login) {
    this.login = login;
  }
  public String getPassword() {
    return password;
  }
  public void setPassword(String password) {
    this.password = password;
  }

  public Boolean getNeedRegistartion() {
    return needRegistartion;
  }

  public void setNeedRegistartion(Boolean needRegistartion) {
    this.needRegistartion = needRegistartion;
  }
  public Integer getUserId() {
    return userId;
  }
  public void setUserId(Integer userId) {
    this.userId = userId;
  }
  
  
  
}
