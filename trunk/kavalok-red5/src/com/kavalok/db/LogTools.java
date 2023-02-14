package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class LogTools extends ModelBase {

  private String action;

  private String ip;

  private Long userId;

  private String login;

  private Long id;

  private Date created;

  private String sys;

  private String type;

  private String recipient;

  private Long recipientId;

  public LogTools() {
    super();
  }

  public LogTools(String action) {
    super();
    this.action = action;
  }

  public LogTools(String action, String ip, Long userId, String login, String type, String recipient, Long recipientId) {
    super();
    this.action = action;
    this.ip = ip;
    this.userId = userId;
    this.login = login;
    this.type = type;
    this.recipient = recipient;
    this.recipientId = recipientId;
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


    public String getRecipient() {
    return recipient;
  }

  public void setRecipient(String recipient) {
    this.recipient = recipient;
  }

  public Long getRecipientId(){
    return recipientId;
  }

  public void setRecipientId(Long recipientId)
  {
    this.recipientId = recipientId;
  }

}
