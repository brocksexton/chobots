package com.kavalok.db;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

@Entity
public class Ban extends ModelBase {
  private User user;

  private int banCount = 0;

  private Date banDate;

  private boolean chatEnabled = true;

  public Ban() {
    super();
    // TODO Auto-generated constructor stub
  }

  public int getBanCount() {
    return banCount;
  }

  public void setBanCount(int banCount) {
    this.banCount = banCount;
  }

  public Date getBanDate() {
    return banDate;
  }

  public void setBanDate(Date banDate) {
    this.banDate = banDate;
  }

  @Column(columnDefinition = "boolean default true")
  public boolean isChatEnabled() {
    return chatEnabled;
  }

  public void setChatEnabled(boolean value) {
    this.chatEnabled = value;
  }

  @OneToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "userId")
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

}
