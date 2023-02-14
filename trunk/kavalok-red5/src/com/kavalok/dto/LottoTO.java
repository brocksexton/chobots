package com.kavalok.dto;

import com.kavalok.db.Lottery;

import java.util.*;


public class LottoTO {

  private int id;

  private String prizeType;

  private String endDate;

  private int ticketPrice;

  private int prize;

  private int totalEntries;

  private boolean enabled;

  private boolean cumulativeMode;

  public LottoTO(Lottery lotto) {
    super();
	
	if(lotto.getPrize() == null){
	id = 0;
	prizeType = "noLottery";
	endDate = "empty";
	enabled = false;
	cumulativeMode = false;
	totalEntries = 0;
	prize = 0;
	ticketPrice = 0;
	}else{
    id = lotto.getId().intValue();
    prizeType = lotto.getPrizeType();
    endDate = lotto.getEndDate();
    enabled = lotto.isEnabled();
    cumulativeMode = lotto.getCumulativeMode();
    totalEntries = lotto.getTotalEntries();
    prize = lotto.getPrize();
    ticketPrice = lotto.getTicketPrice();
	}

  }

  public LottoTO() {
    super();
    // TODO Auto-generated constructor stub
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getPrizeType() {
    return prizeType;
  }

  public void setPrizeType(String prizeType) {
    this.prizeType = prizeType;
  }

  public int getPrize() {
    return prize;
  }

  public void setPrize(int prize) {
    this.prize = prize;
  }

  public int getTicketPrice() {
    return ticketPrice;
  }

  public void setTicketPrice(int ticketPrice) {
    this.ticketPrice = ticketPrice;
  }

  public String getEndDate(){
    return endDate;
  }

  public void setEndDate(String endDate){
    this.endDate = endDate;
  }

  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }

  public int getTotalEntries() {
    return totalEntries;
  }

  public void setTotalEntries(int build) {
    this.totalEntries = build;
  }


  public boolean cumulativeMode() {
    return cumulativeMode;
  }

  public void setCumulativeMode(boolean running) {
    this.cumulativeMode = running;
  }

}
