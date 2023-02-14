package com.kavalok.dto;

import java.util.Date;

public class ChartStatisticsTO extends LoginStatisticsTO {

  private Date date;

  public ChartStatisticsTO(Date date, Long secondsInGame, Integer loginCount) {
    super(secondsInGame, loginCount);
    this.date = date;
  }

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

}
