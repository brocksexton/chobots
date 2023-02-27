package com.kavalok.cache;

import com.kavalok.db.StuffType;


public class StuffTypeWrapper {
  
  private Long id;

  public StuffTypeWrapper(StuffType stuffType) {
    this.id = stuffType.getId();
    this.shopName = stuffType.getShop().getName();
    this.fileName = stuffType.getFileName();
    this.hasColor = stuffType.getHasColor();
    this.doubleColor = stuffType.getDoubleColor();
    this.premium = stuffType.getPremium();
    this.giftable = stuffType.getGiftable();
    this.rainable = stuffType.getRainable();
    this.price = stuffType.getPrice();
	this.emeralds = stuffType.getEmeralds();
    this.type = stuffType.getType();
    this.placement = stuffType.getPlacement();
    this.info = stuffType.getInfo();
    this.itemOfTheMonth = stuffType.getItemOfTheMonth();
    this.name = stuffType.getName();
    this.groupNum = stuffType.getGroupNum();
      this.otherInfo = stuffType.getOtherInfo();
  }


  private String shopName;

  private String fileName;

  private Boolean hasColor;
  private Boolean doubleColor;


  private Boolean premium;

  private Boolean giftable;

  private Boolean rainable;

  private int price;

  private int emeralds;
  
  private String type;

  private String placement;

  private String info;

  private String itemOfTheMonth;

  private String name;

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }

    private String otherInfo;

  private int groupNum = 0;

  public String getFileName() {
    return fileName;
  }

  public void setFileName(String fileName) {
    this.fileName = fileName;
  }

  public Boolean getHasColor() {
    return hasColor;
  }

  public void setHasColor(Boolean hasColor) {
    this.hasColor = hasColor;
  }



  public Boolean getDoubleColor() {
    return doubleColor;
  }

  public void setDoubleColor(Boolean doubleColor) {
    this.doubleColor = doubleColor;
  }


  public Boolean getPremium() {
    return premium;
  }

  public void setPremium(Boolean premium) {
    this.premium = premium;
  }

  public Boolean getGiftable() {
    return giftable;
  }

  public void setGiftable(Boolean giftable) {
    this.giftable = giftable;
  }

  public Boolean getRainable() {
    return rainable;
  }

  public void setRainable(Boolean rainable) {
    this.rainable = rainable;
  }

  public int getPrice() {
    return price;
  }

  public void setPrice(int price) {
    this.price = price;
  }
  
  public int getEmeralds() {
    return emeralds;
  }

  public void setEmeralds(int emeralds) {
    this.emeralds = emeralds;
  }
  
  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getPlacement() {
    return placement;
  }

  public void setPlacement(String placement) {
    this.placement = placement;
  }

  public String getInfo() {
    return info;
  }

  public void setInfo(String info) {
    this.info = info;
  }

  public String getItemOfTheMonth() {
    return itemOfTheMonth;
  }

  public void setItemOfTheMonth(String itemOfTheMonth) {
    this.itemOfTheMonth = itemOfTheMonth;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getGroupNum() {
    return groupNum;
  }

  public void setGroupNum(int groupNum) {
    this.groupNum = groupNum;
  }

  public String getShopName() {
    return shopName;
  }

  public void setShopName(String shopName) {
    this.shopName = shopName;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

}
