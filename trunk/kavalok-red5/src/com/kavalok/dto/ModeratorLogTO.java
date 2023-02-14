package com.kavalok.dto;

import com.kavalok.db.ModeratorLog;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

public class ModeratorLogTO {

  private String message;

  private Long panel_id;
  
  private Long id;

  private Date created;
  
  private Boolean trolol;

  public ModeratorLogTO(ModeratorLog message) {
    super();
    this.id = message.getId();
	this.trolol = message.getTrolol();
    this.message = message.getMessage();
    this.panel_id = message.getPanelId();
    this.created  = message.getCreated();
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }
  
  public void setTrolol(Boolean trol){
   this.trolol = trol;
  }
  
  public Boolean getTrolol(){
   return trolol;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getPanelId(){
  return panel_id;
  }
  
  public void setPanelId(Long id){
  this.panel_id = id;
  }
  
  public Date getCreated(){
  return created;
  }
  
  public void setCreated(Date created){
  this.created = created;
  }

}
