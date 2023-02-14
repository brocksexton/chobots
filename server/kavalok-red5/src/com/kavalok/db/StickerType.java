package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.validator.NotNull;

@Entity
public class StickerType extends ModelBase {
  private String name;
  private String type;
  private Integer value;
  private Boolean enabled;
  
  
  public StickerType() {
    super();
  }
 
  @NotNull
  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }

  public String getType() {
    return type;
  }
  public void setType(String type) {
    this.type = type;
  }

  public Integer getValue(){
    return value;
  }

  public void setValue(Integer value){
    this.value = value;
  }

  @NotNull
  @Column(columnDefinition = "boolean default false")
  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }

}
