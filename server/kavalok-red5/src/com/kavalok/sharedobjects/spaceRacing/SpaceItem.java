package com.kavalok.sharedObjects.spaceRacing;

public class SpaceItem {
  
  private Integer num;
  private Integer x;
  private Integer y;
  public SpaceItem(Integer num, Integer x, Integer y) {
    super();
    this.num = num;
    this.x = x;
    this.y = y;
  }
  public Integer getNum() {
    return num;
  }
  public void setNum(Integer num) {
    this.num = num;
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
  
}
