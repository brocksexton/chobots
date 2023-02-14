package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class MarketLogs extends ModelBase {
	
  private Long id;
  private Long userId;
  private String username;
  private String ip;
  private Integer marketId;
  private String action;
  private Integer amount;

  public MarketLogs() {
    super();
  }

  public MarketLogs(Long userId, String username, String ip, int marketId, String action, int amount) {
    super();
	this.userId = userId;
	this.username = username;
    this.ip = ip;
    this.marketId = marketId;
	this.action = action;
    this.amount = amount;
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }
  
  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }
  
  public Integer getMarketId() {
    return marketId;
  }

  public void setMarketId(Integer marketId) {
    this.marketId = marketId;
  }
  
  public String getAction() {
    return action;
  }

  public void setAction(String action) {
    this.action = action;
  }
  
  public Integer getAmount() {
    return amount;
  }

  public void setAmount(Integer amount) {
    this.amount = amount;
  }

  
}
