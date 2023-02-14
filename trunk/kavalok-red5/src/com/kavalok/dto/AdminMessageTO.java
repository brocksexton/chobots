package com.kavalok.dto;

import com.kavalok.db.AdminMessage;

public class AdminMessageTO {

  private Integer id;

  private String message;

  private String user;

  private String email;

  public AdminMessageTO(AdminMessage message) {
    super();
    this.id = message.getId().intValue();
    this.message = message.getMessage();
    this.user = message.getUser().getLogin();
    this.email = message.getUser().getEmail();
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public String getUser() {
    return user;
  }

  public void setUser(String user) {
    this.user = user;
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

}
