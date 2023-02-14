package com.kavalok.dto;

import com.kavalok.db.StickerType;

import java.util.*;


public class StickerTypeTO {

  private int id;

  private int value;

  private Boolean enabled;

  private String name;


public StickerTypeTO(StickerType stickers) {
    super();
    id = stickers.getId().intValue();
    value = stickers.getValue();
    enabled = stickers.isEnabled();
    name = stickers.getName();
  }

  public StickerTypeTO() {
    super();
    // TODO Auto-generated constructor stub
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public int getValue(){
    return value;
  }

  public void setValue(int value){
    this.value = value;

  }

  public String getName(){
    return name;
  }

  public void setName(String name){
    this.name = name;
  }

public Boolean getEnabled(){
  return enabled;
}

public void setEnabled(Boolean enabled){
  this.enabled = enabled;
}
}
