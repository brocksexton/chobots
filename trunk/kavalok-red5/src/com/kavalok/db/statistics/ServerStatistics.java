package com.kavalok.db.statistics;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;

import com.kavalok.db.ModelBase;
import com.kavalok.db.Server;

@Entity
public class ServerStatistics extends ModelBase {
  private Server server;
  private Integer usersCount;
  
  public ServerStatistics(Server server, Integer usersCount) {
    super();
    this.server = server;
    this.usersCount = usersCount;
  }
  public ServerStatistics() {
    super();
  }
  @ManyToOne
  public Server getServer() {
    return server;
  }
  public void setServer(Server server) {
    this.server = server;
  }
  public Integer getUsersCount() {
    return usersCount;
  }
  public void setUsersCount(Integer usersCount) {
    this.usersCount = usersCount;
  }
  
  
}
