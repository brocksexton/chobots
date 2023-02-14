package com.kavalok.db;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class Competition extends ModelBase {
  private String name;
  private Date start;
  private Date finish;
  
  
  public Competition() {
    super();
  }
  public Competition(String name, Date start, Date finish) {
    super();
    this.name = name;
    this.start = start;
    this.finish = finish;
  }
  @NotNull
  @Column(unique = true)
  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public Date getStart() {
    return start;
  }
  public void setStart(Date start) {
    this.start = start;
  }
  public Date getFinish() {
    return finish;
  }
  public void setFinish(Date finish) {
    this.finish = finish;
  }
}
