package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class ModeratorLog extends ModelBase {

  private String messsage;

  private Long panel_id;
  
  private Long id;

  private Date created;
  
  private Boolean trolol;

  public ModeratorLog() {
    super();
  }

  public ModeratorLog(String msg) {
    super();
    this.messsage = msg;
  }

  public ModeratorLog(String msg, Long panel_id) {
    super();
    this.messsage = msg;
    this.panel_id = panel_id;
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }
  
  public void setTrolol(Boolean trol){
  this.trolol = trol;
  }
  
  public Boolean getTrolol(){
  return trolol;
  }

  @Type(type = "text")
  public String getMessage() {
    return messsage;
  }

  public void setMessage(String msg) {
    this.messsage = msg;
  }


  public Long getPanelId() {
    return panel_id;
  }

  public void setPanelId(Long panel_id) {
    this.panel_id = panel_id;
  }

}
