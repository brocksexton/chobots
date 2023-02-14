package com.kavalok.dto;

public class PurchaseStatisticsTO {

  private String itemName;

  private Integer count;

  public PurchaseStatisticsTO(String itemName, Integer count) {
    super();
    this.itemName = itemName;
    this.count = count;
  }

  public String getItemName() {
    return itemName;
  }

  public void setItemName(String itemName) {
    this.itemName = itemName;
  }

  public Integer getCount() {
    return count;
  }

  public void setCount(Integer count) {
    this.count = count;
  }

}
