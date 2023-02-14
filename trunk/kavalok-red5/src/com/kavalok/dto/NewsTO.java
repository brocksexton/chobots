package com.kavalok.dto;

import com.kavalok.db.News;

public class NewsTO {

  private int id;

  private String dates;

  private String info;

  private String image;

  private String charName;

  private boolean show;


  public NewsTO(News news) {
    super();
    id = news.getId().intValue();
    dates = news.getDates();
    info = news.getInfo();
    image = news.getImage();
    charName  = news.getCharName();
    show = news.isShow();
  }

  public NewsTO() {
    super();
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getDates() {
    return dates;
  }

  public void setDates(String dates) {
    this.dates = dates;
  }

  public String getInfo() {
    return info;
  }

  public void setInfo(String info) {
    this.info = info;
  }

  public String getImage() {
    return image;
  }

  public void setImage(String image) {
    this.image = image;
  }


  public String getCharName() {
    return charName;
  }

  public void setCharName(String charName) {
    this.charName = charName;
  }


  public boolean isShow() {
    return show;
  }

  public void setShow(boolean show) {
    this.show = show;
  }


}
