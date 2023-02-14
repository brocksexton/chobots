package com.kavalok.billing.transaction;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class StuffProduct {

  @Element
  private Integer typeId;

  @Element
  private Integer color;

  @Element
  private Integer count;
  
  public StuffProduct() {
    super();
  }

  public StuffProduct(Integer typeId, Integer count, Integer color) {
    this.typeId = typeId;
    this.count = count;
    this.color = color;
  }

  public Integer getColor() {
    return color;
  }

  public void setColor(Integer color) {
    this.color = color;
  }

  public Integer getCount() {
    return count;
  }

  public void setCount(Integer count) {
    this.count = count;
  }

  public Integer getTypeId() {
    return typeId;
  }

  public void setTypeId(Integer typeId) {
    this.typeId = typeId;
  }

}
