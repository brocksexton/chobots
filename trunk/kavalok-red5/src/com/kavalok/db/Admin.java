package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import com.kavalok.permissions.AccessAdmin;

@Entity
public class Admin extends LoginModelBase {
  private Long id;
  private Integer permissionLevel = 0;
  private String realName;
  private Boolean magic;
  private String login;
  private String password;

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }
  
  

  @SuppressWarnings("unchecked")
  @Override
  @Transient
  public Class getAccessType() {
    return AccessAdmin.class;
  }

  public Integer getPermissionLevel() {
    return permissionLevel;
  }


  public void setPermissionLevel(Integer permissionLevel) {
    this.permissionLevel = permissionLevel == null ? 0 : permissionLevel;
  }

  public String getRealName() {
    return realName;
  }


  public void setRealName(String realName) {
    this.realName = realName == null ? "Yolo" : realName;
  }

  public Boolean getMagic(){
	return magic;
}

 public void setMagic(Boolean magic){
	this.magic = magic;
}


}
