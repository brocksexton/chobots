package com.kavalok.dto.stuff;

public class StuffTOBase {
  private String fileName;
  private String type;
  private String name;
  private Long id;
  private int price;
  private int emeralds;
  private Boolean hasColor;
  private Boolean doubleColor;

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

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getFileName() {
    return fileName;
  }

  public void setFileName(String fileName) {
    this.fileName = fileName;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
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

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
}
