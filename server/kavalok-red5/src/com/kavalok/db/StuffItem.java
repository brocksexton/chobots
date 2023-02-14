package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;

import org.hibernate.validator.NotNull;

import com.kavalok.dao.QueriesNames;

@Entity
@NamedQuery(name = QueriesNames.PURCHASE_STATISTICS_SELECT_FOR_STUFF, query = "select item, count(*) "
  + "from StuffItem as item " + "where item.created < :maxDate and item.created > :minDate "
  + "group by item.type " + "order by count(*) desc")
public class StuffItem extends ModelBase {

  private Integer x;

  private Integer y;

  private Integer level;

  private Integer rotation;

  private Integer color;

  private Integer colorSec;

  private boolean used;

  private GameChar gameChar;

  private StuffType type;

  private Long type_id;
  
  public StuffItem() {
    super();
    // TODO Auto-generated constructor stub
  }

  public StuffItem(StuffType type) {
    super();
    this.type = type;
  }

  public void resetOwner() {
    x = 0;
    y = 0;
    used = false;
  }

  public Integer getLevel() {
    return level;
  }

  public void setLevel(Integer level) {
    this.level = level;
  }

 @ManyToOne(fetch=FetchType.LAZY)
  public GameChar getGameChar() {
    return gameChar;
  }

  public void setGameChar(GameChar gameChar) {
    this.gameChar = gameChar;
  }

  @ManyToOne(fetch=FetchType.LAZY)
  @NotNull
  public StuffType getType() {
    return type;
  }

  public void setType(StuffType type) {
    this.type = type;
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

  public boolean isUsed() {
    return used;
  }

  public void setUsed(boolean used) {
    this.used = used;
  }

  public Integer getColor() {
    return color;
  }

  public void setColor(Integer color) {
    this.color = color;
  }

    public Integer getColorSec() {
    return colorSec;
  }

  public void setColorSec(Integer colorSec) {
    this.colorSec = colorSec;
  }

  public Integer getRotation() {
    return rotation;
  }

  public void setRotation(Integer rotation) {
    this.rotation = rotation;
  }
  
  @Column(insertable=false, updatable=false)
  public Long getType_id() {
    return type_id;
  }

  public void setType_id(Long type_id) {
    this.type_id = type_id;
  }

}
