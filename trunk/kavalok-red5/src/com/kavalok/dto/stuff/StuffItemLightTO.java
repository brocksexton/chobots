package com.kavalok.dto.stuff;

import com.kavalok.cache.StuffTypeCache;
import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.db.StuffItem;

public class StuffItemLightTO extends StuffTOBase {

  private String placement;

  private Boolean used;

  private Integer x;

  private Integer y;

  private Integer level;

  private Integer color;

  private Integer colorSec;

  private Integer rotation;

  private Boolean giftable;

  private String shopName;

  private Boolean premium;

  private String info;

  private String lolName;

  private Object fixNull(Object value) {
    if (value == null)
      return "";
    return value;
  }
  
  @Override
  public String toString() {
    return fixNull(getId()).toString();
  }

  public String toStringPresentation() {
    return getFileName() + "|" + getType() + "|" + fixNull(getLolname()) + "|" + fixNull(getId()) + "|"
        + fixNull(getPrice()) + "|" + (Boolean.TRUE.equals(getHasColor()) ? "t" : "f") + "|" + fixNull(getPlacement())
        + "|" + (Boolean.TRUE.equals(getUsed()) ? "t" : "f") + "|" + fixNull(getX()) + "|" + fixNull(getY()) + "|"
        + fixNull(getLevel()) + "|" + fixNull(getColor()) + "|" + fixNull(getRotation()) + "|"
        + (Boolean.TRUE.equals(getGiftable()) ? "t" : "f") + "|" + fixNull(getShopName()) + "|"
        + (Boolean.TRUE.equals(getPremium()) ? "t" : "f") + "|" + fixNull(getInfo())+ "|" + (Boolean.TRUE.equals(getDoubleColor()) ? "t" : "f") + "|" + fixNull(getColorSec());

  }

  public StuffItemLightTO(StuffItem item) {
    super();

    setId(item.getId());

    StuffTypeWrapper itemType = StuffTypeCache.getInstance().getStuffType(item.getType_id());
    if (itemType == null) {
      itemType = StuffTypeCache.getInstance().putStuffType(item.getType());
    }
    setFileName(itemType.getFileName());
    setType(itemType.getType());
    setPrice(itemType.getPrice());
    setHasColor(itemType.getHasColor());
    setDoubleColor(itemType.getDoubleColor());
    this.used = item.isUsed();
    this.placement = itemType.getPlacement();
    this.x = item.getX();
    this.y = item.getY();
    this.level = item.getLevel();
    this.color = item.getColor();
    this.giftable = itemType.getGiftable();
    this.shopName = itemType.getShopName();
    this.rotation = item.getRotation();
    this.premium = itemType.getPremium();
    this.info = itemType.getInfo();
    this.colorSec = item.getColorSec();
    this.lolName = itemType.getName();
  }

  public StuffItemLightTO() {
    super();
  }

  public Boolean getUsed() {
    return used;
  }

  public void setUsed(Boolean used) {
    this.used = used;
  }

  public Integer getLevel() {
    return level;
  }

  public void setLevel(Integer level) {
    this.level = level;
  }

  public String getPlacement() {
    return placement;
  }

  public void setPlacement(String placement) {
    this.placement = placement;
  }

  public String getLolname(){
    return lolName;
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

  public Boolean getGiftable() {
    return giftable;
  }

  public void setGiftable(Boolean giftable) {
    this.giftable = giftable;
  }

  public String getShopName() {
    return shopName;
  }

  public void setShopName(String shopName) {
    this.shopName = shopName;
  }

  public Integer getRotation() {
    return rotation;
  }

  public void setRotation(Integer rotation) {
    this.rotation = rotation;
  }

  public Boolean getPremium() {
    return premium;
  }

  public void setPremium(Boolean premium) {
    this.premium = premium;
  }

  public String getInfo() {
    return info;
  }

  public void setInfo(String info) {
    this.info = info;
  }

}
