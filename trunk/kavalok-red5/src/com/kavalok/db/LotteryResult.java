package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;

import org.hibernate.validator.NotNull;

import com.kavalok.dao.QueriesNames;

@Entity
public class LotteryResult extends ModelBase {

  private String login;

  private Long user_id;

  private Long lottoId;

  private Integer ticketPrice;

  private Integer entries;

  public LotteryResult() {
    super();
  }

  public LotteryResult(String login, Long userId, Long lottoId, Integer ticketPrice, Integer entries) {
    super();
    this.login = login;
    this.user_id = userId;
    this.lottoId = lottoId;
    this.ticketPrice = ticketPrice;
    this.entries = entries;
  }

  public Long getLottoId() {
    return lottoId;
  }

  public void setLottoId(Long lottoId) {
    this.lottoId = lottoId;
  }

  public Integer getEntries(){
    return entries;
  }

  public void setEntries(Integer entries){
    this.entries = entries;
  }

  public Integer getTicketPrice(){
    return ticketPrice;
  }

  public void setTicketPrice(Integer ticketPrice){
    this.ticketPrice = ticketPrice;
  }

  @Column(insertable = false, updatable = false)
  public Long getUser_id() {
    return user_id;
  }

  public void setUser_id(Long user_id) {
    this.user_id = user_id;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

}
