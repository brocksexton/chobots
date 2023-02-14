package com.kavalok.dto.admin;

import java.util.Date;

public class ActivationStatisticsTO {
  private Integer registered;
  private Integer activated;
  private Date date;

  public ActivationStatisticsTO(Integer registered, Integer activated) {
    super();
    this.registered = registered;
    this.activated = activated;
  }
  public ActivationStatisticsTO() {
    super();
  }
  public ActivationStatisticsTO(Integer registered, Integer activated, Date date) {
    super();
    this.registered = registered;
    this.activated = activated;
    this.date = date;
  }
  public Date getDate() {
    return date;
  }
  public void setDate(Date date) {
    this.date = date;
  }
  public Integer getRegistered() {
    return registered;
  }
  public void setRegistered(Integer registered) {
    this.registered = registered;
  }
  public Integer getActivated() {
    return activated;
  }
  public void setActivated(Integer activated) {
    this.activated = activated;
  }
}
