package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import com.kavalok.permissions.AccessMagic;

@Entity
public class MagicPanel extends LoginModelBase {
  private Long id;
  private Integer permissionLevel = 0;

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
    return AccessMagic.class;
  }

  public Integer getPermissionLevel() {
    return permissionLevel;
  }

  public void setPermissionLevel(Integer permissionLevel) {
    this.permissionLevel = permissionLevel == null ? 0 : permissionLevel;
  }

}
