package com.kavalok.dto;

import java.util.Date;

public class ServerStatisticsTO {

  private Integer usersCount;
  private String server;
  private Date date;
  
  
  public ServerStatisticsTO(String server, Integer usersCount, Date date) {
    super();
    this.usersCount = usersCount;
    this.server = server;
    this.date = date;
  }
  public Integer getUsersCount() {
    return usersCount;
  }
  public void setUsersCount(Integer usersCount) {
    this.usersCount = usersCount;
  }
  public String getServer() {
    return server;
  }
  public void setServer(String server) {
    this.server = server;
  }
  public Date getDate() {
    return date;
  }
  public void setDate(Date date) {
    this.date = date;
  }
  
  
  
}
