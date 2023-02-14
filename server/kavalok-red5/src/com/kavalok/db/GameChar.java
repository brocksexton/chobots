package com.kavalok.db;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

@Entity
public class GameChar extends ModelBase {

  private Long userId;
  private Double money = 0d;
  private Double emeralds = 0d;
  private Double candy = 0d;
  private Double totalMoneyEarned = 0d;
  private Double totalMoneyEarnedByInvites = 0d;
  private Double totalBonusMoney = 0d;
  private String body;
  private String gender;
  private String chatColor = "default";
  private String blogLink;
  private Integer color;
  private List<StuffItem> stuffItems = new ArrayList<StuffItem>();
  private List<GameChar> ignoreList = new ArrayList<GameChar>();
  private Boolean firstLogin = true;
  private Boolean showCharNames = false;
  private User user;
  private StuffItem playerCard;
  private Date magicDate;
  private Date bankVisit;
  private Date lastDaily;
  
  public GameChar() {
    super();
    // TODO Auto-generated constructor stub
  }

  @OneToOne(mappedBy = "gameChar")
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public String getBody() {
    return body;
  }

  public void setBody(String body) {
    this.body = body;
  }

  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public String getChatColor() {
    return chatColor;
  }

  public void setChatColor(String chatColor) {
    this.chatColor = chatColor;
  }

  public String getBlogLink() {
    return blogLink;
  }

  public void setBlogLink(String blogLink) {
    this.blogLink = blogLink;
  }

  @Transient
  public String getLogin() {
    return getUser().getLogin();
  }

  //
  // public void setName(String name) {
  // this.name = name;
  // }

  @OneToMany(mappedBy = "gameChar", fetch = FetchType.LAZY)
  public List<StuffItem> getStuffItems() {
    if (stuffItems == null)
      stuffItems = new ArrayList<StuffItem>();
    return stuffItems;
  }

  public void setStuffItems(List<StuffItem> stuffItems) {
    this.stuffItems = stuffItems;
  }

  @ManyToMany(fetch = FetchType.LAZY)
  @JoinTable(name = "GAMECHAR_IGNORE_LIST")
  public List<GameChar> getIgnoreList() {
    return ignoreList;
  }

  public void setIgnoreList(List<GameChar> ignoreList) {
    this.ignoreList = ignoreList;
  }

  @Column(columnDefinition = "boolean default true") 
  public Boolean getFirstLogin() {
    return firstLogin;
  }

  public void setFirstLogin(Boolean firstLogin) {
    this.firstLogin = firstLogin;
  }

  @Transient
  public boolean hasItem(StuffType type) {
    for (StuffItem item : stuffItems) {
      if (item.getType().getId().equals(type.getId())) {
        return true;
      }
    }
    return false;
  }

  public Integer getColor() {
    return color;
  }

  public void setColor(Integer color) {
    this.color = color;
  }

  public Double getTotalMoneyEarned() {
    return totalMoneyEarned == null ? 0 : totalMoneyEarned;
  }

  public void setTotalMoneyEarned(Double totalMoneyEarned) {
    this.totalMoneyEarned = totalMoneyEarned;
  }

  public Double getTotalMoneyEarnedByInvites() {
    return totalMoneyEarnedByInvites == null ? 0 : totalMoneyEarnedByInvites;
  }

  public void setTotalMoneyEarnedByInvites(Double totalMoneyEarnedByInvites) {
    this.totalMoneyEarnedByInvites = totalMoneyEarnedByInvites;
  }

  public Double getTotalBonusMoney() {
    return totalBonusMoney;
  }

  public void setTotalBonusMoney(Double totalBonusMoney) {
    this.totalBonusMoney = totalBonusMoney == null ? 0 : totalBonusMoney;
  }

  public void setMoney(Double money) {
    this.money = money;
  }

  public Double getMoney() {
    return money;
  }

  public void setCandy(Double candy) {
    this.candy = candy;
  }

  public Double getCandy() {
    return candy;
  }


  public void setEmeralds(Double emeralds) {
    this.emeralds = emeralds;
  }

  public Double getEmeralds() {
    return emeralds;
  }

  public Boolean getShowCharNames() {
    return showCharNames;
  }

  public void setShowCharNames(Boolean showCharNames) {
    this.showCharNames = showCharNames == null ? true : showCharNames;
  }

  @OneToOne
	public StuffItem getPlayerCard() {
		return playerCard;
	}

	public void setPlayerCard(StuffItem playerCard) {
		this.playerCard = playerCard;
	}

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

public Date getMagicDate() {
	return magicDate;
}

public void setMagicDate(Date magicDate) {
	this.magicDate = magicDate;
}


public Date getBankVisit() {
	return bankVisit;
}

public void setBankVisit(Date bankVisit) {
	this.bankVisit = bankVisit;
}
public Date getLastDaily() {
  return lastDaily;
}

public void setLastDaily(Date lastDaily) {
  this.lastDaily = lastDaily;
}
}
