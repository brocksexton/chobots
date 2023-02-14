package com.kavalok.db;

import javax.persistence.Entity;

@Entity
public class Game extends ModelBase {

  private String name;


  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

}
