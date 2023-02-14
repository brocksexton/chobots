package com.kavalok.dto.stuff;

import com.kavalok.db.StuffItem;


public class StuffItemTO {

  private Long id;

  private Integer x;

  private Integer y;

  private Integer level;

  private Integer rotation;

  private Integer color;

  private boolean used;

  private StuffTypeTO type;

  public StuffItemTO() {
    super();
  }
  public StuffItemTO(StuffItem item) {
    super();
    this.id = item.getId();
    this.x = item.getX();
    this.y = item.getY();
    this.level = item.getLevel();
    this.rotation = item.getRotation();
    this.color = item.getColor();
    this.used = item.isUsed();
    this.type = new StuffTypeTO(item.getType());
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Integer getX() {
    return x;
  }

  public void setX(Integer x) {
    this.x = x;
  }

  public Integer getY() {
    return y;
  }

  public void setY(Integer y) {
    this.y = y;
  }

  public Integer getLevel() {
    return level;
  }

  public void setLevel(Integer level) {
    this.level = level;
  }

  public Integer getColor() {
    return color;
  }

  public void setColor(Integer color) {
    this.color = color;
  }

  public boolean isUsed() {
    return used;
  }

  public void setUsed(boolean used) {
    this.used = used;
  }

  public StuffTypeTO getType() {
    return type;
  }

  public void setType(StuffTypeTO type) {
    this.type = type;
  }
  public Integer getRotation() {
    return rotation;
  }
  public void setRotation(Integer rotation) {
    this.rotation = rotation;
  }
  
  
}
