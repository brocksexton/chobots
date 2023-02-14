package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class BlackIP extends ModelBase {

  private String ip;

  private String reason;

  private boolean baned = true;

  public BlackIP() {
    super();
    // TODO Auto-generated constructor stub
  }

  @NotNull
  @Column(unique = true, length = 15)
  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  @Column(columnDefinition = "boolean default true")
  public boolean isBaned() {
    return baned;
  }

  public void setBaned(boolean baned) {
    this.baned = baned;
  }

}
