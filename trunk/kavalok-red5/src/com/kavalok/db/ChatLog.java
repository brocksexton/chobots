package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class ChatLog extends ModelBase {

  private String message;
  private String username;
  private Long userId;
  private Date date;

  private String ip;
  private String location;
  private String server;

  private Long id;


  public ChatLog() {
    super();
  }


  public ChatLog(Long userId, String username, String message, String ip, String location, String server) {
    super();
this.userId = userId;
    this.message = message;
this.username = username;
    date = new Date();
    this.ip = ip;
this.location = location;
this.server = server;

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
  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

  public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }


  public String getServer() {
    return server;
  }

  public void setServer(String server) {
    this.server = server;
  }
  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }





}
