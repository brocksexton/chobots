package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class GiftHistory extends ModelBase {

  private String from;

  private String item;

  private String to;

  private String ip;

  private Long id;

  private Date created;

  public GiftHistory() {
    super();
  }

  public GiftHistory(String messsage) {
    super();

  }

  public GiftHistory(String from, String item, String to, String ip) {
    super();
    this.from = from;
    this.item = item;
    this.to = to;
    this.ip = ip;
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getFrom() {
    return from;
  }

  public void setFrom(String from) {
    this.from = from;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

  public String getTo() {
    return to;
  }

  public void setTo(String to) {
    this.to = to;
  }
  public String getItem() {
    return item;
  }

  public void setItem(String item) {
    this.item = item;
  }
}
