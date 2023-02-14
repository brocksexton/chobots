package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.validator.NotNull;

@Entity
public class Lottery extends ModelBase {
  private String prizeType;
  private Integer prize;
  private Integer ticketPrice;
  private String endDate;
  private Integer totalEntries;
  private Boolean enabled;
  private Boolean cumulativeMode;
  
  
  public Lottery() {
    super();
  }
  public Lottery(String prizeType, Integer prize, Integer ticketPrice) {
    super();
    this.prizeType = prizeType;
    this.prize = prize;
    this.ticketPrice = ticketPrice;
  }
  @NotNull
  public String getPrizeType() {
    return prizeType;
  }
  public void setPrizeType(String prizeType) {
    this.prizeType = prizeType;
  }
/*
  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }
*/
  public String getEndDate() {
    return endDate;
  }
  public void setEndDate(String endDate) {
    this.endDate = endDate;
  }

  public Integer getPrize(){
    return prize;
  }

  public void setPrize(Integer prize){
    this.prize = prize;
  }

  public Integer getTicketPrice(){
    return ticketPrice;
  }

  public void setTicketPrice(Integer ticketPrice){
    this.ticketPrice = ticketPrice;
  }

  public Integer getTotalEntries(){
    return totalEntries;
  }

  public void setTotalEntries(Integer totalEntries){
    this.totalEntries = totalEntries;
  }

  @NotNull
  @Column(columnDefinition = "boolean default false")
  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }

    @NotNull
  @Column(columnDefinition = "boolean default false")
  public boolean getCumulativeMode() {
    return cumulativeMode;
  }

  public void setCumulativeMode(boolean cumulativeMode) {
    this.cumulativeMode = cumulativeMode;
  }
}
