package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class ClientError extends ModelBase {

  private String messsage;

 // private String action;

  private Date date;

  private Integer count;

  private String ip;

  private Long panel_id;

  private Date updated;

  private Long id;

  private Date created;

  public ClientError() {
    super();
  }

  public ClientError(String messsage) {
    super();
    this.messsage = messsage;
    count = 0;
    updated = new Date();
  }

  public ClientError(String action, String ip, Long panel_id, Boolean value) {
    super();
    this.messsage = action;
    updated = new Date();
    this.ip = ip;
    this.panel_id = panel_id;
   // date = new Date();
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
    return messsage;
  }

  public void setMessage(String message) {
    this.messsage = message;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

  public Long getPanelId() {
    return panel_id;
  }

  public void setPanelId(Long panel_id) {
    this.panel_id = panel_id;
  }

  public Integer getCount() {
    return count;
  }

  public void setCount(Integer count) {
    this.count = count;
  }

  public Date getUpdated() {
    return updated;
  }

  public void setUpdated(Date updated) {
    this.updated = updated;
  }



  /*public String getAction() {
    return action;
  }

  public void setAction(String action) {
    this.action = action;
  }*/

}
