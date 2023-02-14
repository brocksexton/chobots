package com.kavalok.dto;

import java.util.Date;

import com.kavalok.db.Competition;

public class CompetitionTO {
  private String name;
  private Date start;
  private Date finish;
  private Boolean open;
  
  public CompetitionTO(Competition competition) {
    super();
    name = competition.getName();
    start = competition.getStart();
    finish = competition.getFinish();
    Date now = new Date();
    open = start.before(now) && finish.after(now);
  }
  public CompetitionTO() {
    super();
  }
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
  public Boolean getOpen() {
    return open;
  }
  public void setOpen(Boolean open) {
    this.open = open;
  }
  
}
