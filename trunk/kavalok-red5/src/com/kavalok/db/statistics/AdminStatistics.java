package com.kavalok.db.statistics;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;

import java.util.Date;
import org.hibernate.validator.NotNull;

import com.kavalok.db.ModelBase;
import com.kavalok.db.Server;

@Entity
public class AdminStatistics extends ModelBase {
  private Date date;
  private String action;
  
  public AdminStatistics(Date date, String aciton) {
    super();
    this.date = date;
    this.action = action;
  }
  public AdminStatistics() {
    super();
  }
 /* @ManyToOne
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
  }*/
  	  @NotNull
	  public Date getDate() {
	    return date;
	  }

	  public void setDate(Date date) {
	    this.date = date;
	  }

	  public String getAction() {
	    return action;
	  }

	  public void setAction(String action) {
	    this.action = action;
	  }
  
}
