package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

import com.kavalok.utils.HibernateUtil;

@Entity
public class Config extends ModelBase {

  private String name;
  
  private byte[] value;

  public Config() {
    super();
  }

  public Config(String name) {
    super();
    this.name = name;
  }

  @Column(unique = true)
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }


  public byte[] getValue() {
    return value;
  }

  public void setValue(byte[] value) {
    this.value = value;
  }

  @Transient
  public Object getObjectValue() {
    return HibernateUtil.deserialize(value);
  }

  public void setObjectValue(Object objectValue) {
    this.value = HibernateUtil.serialize(objectValue);
  }

}
