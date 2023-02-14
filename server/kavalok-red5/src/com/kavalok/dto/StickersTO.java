package com.kavalok.dto;

import com.kavalok.db.Stickers;

import java.util.*;


public class StickersTO {

  private int id;

  private int stickerId;

  private Boolean valid;


  public StickersTO(Stickers stickers) {
    super();
    id = stickers.getId().intValue();
    stickerId = stickers.getStickerId();
    valid = stickers.getValid();
  }

  public StickersTO() {
    super();
    // TODO Auto-generated constructor stub
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public int getStickerId(){
    return stickerId;
  }

  public void setStickerId(int stickerId){
    this.stickerId = stickerId;

  }

public Boolean getValid(){
  return valid;
}

public void setValid(Boolean valid){
  this.valid = valid;
}
}
