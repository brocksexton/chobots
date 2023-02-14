package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class LogAdmin extends ModelBase {

  private String action;

  private String ip;

  private Long userId;

  private String login;

  private Long id;

  private Date created;

  private String sys;

  private String type;

  public LogAdmin() {
    super();
  }

  public LogAdmin(String action) {
    super();
    this.action = action;
  }

  public LogAdmin(String action, String ip, Long userId, String login, String type) {
    super();
    this.action = action;
    this.ip = ip;
    this.userId = userId;
    this.login = login;
    this.type = type;
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  @Type(type = "text")
  public String getAction() {
    return action;
  }

  public void setAction(String action) {
    this.action = action;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

    public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

}
