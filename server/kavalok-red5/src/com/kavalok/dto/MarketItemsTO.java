package com.kavalok.dto;

import com.kavalok.db.MarketItems;
import java.util.Date;
public class MarketItemsTO {
  
	private int id;
	private boolean active;
	private int createdBy;
	private int itemId;
	private int currentBid;
	private Date createdDate;
	private Date endDate;
	private int buyerId;
	private int bidNumber;
	private int buyNowPrice;

  public MarketItemsTO(MarketItems marketItems) {
    super();
    id = marketItems.getId().intValue();
	active = marketItems.isActive();
    createdBy = marketItems.getCreatedBy();
    itemId = marketItems.getItemId();
    currentBid = marketItems.getCurrentBid();
    createdDate = marketItems.getCreatedDate();
    endDate = marketItems.getEndDate();
    buyerId = marketItems.getBuyerId();
    bidNumber = marketItems.getBidNumber();
    buyNowPrice = marketItems.getBuyNowPrice();
  }

  public MarketItemsTO() {
    super();
  }

  public int getId() {
    return id;
  }
  
  public void setId(int id) {
    this.id = id;
  }
  
  public boolean isActive() {
    return active;
  }

  public void setActive(boolean active) {
    this.active = active;
  }
  
  public int getCreatedBy() {
    return createdBy;
  }
  
  public void setCreatedBy(int createdBy) {
    this.createdBy = createdBy;
  }
  
  public int getItemId() {
    return itemId;
  }
  
  public void setItemId(int itemId) {
    this.itemId = itemId;
  }
  
  public int getCurrentBid() {
    return currentBid;
  }
  
  public void setCurrentBid(int currentBid) {
    this.currentBid = currentBid;
  }
  
  public Date getCreatedDate() {
    return createdDate;
  }
  
  public void setCreatedDate(Date createdDate) {
    this.createdDate = createdDate;
  }
  
  public Date getEndDate() {
    return endDate;
  }
  
  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }
  
  public int getBuyerId() {
    return buyerId;
  }
  
  public void setBuyerId(int buyerId) {
    this.buyerId = buyerId;
  }
  
  public int getBidNumber() {
    return bidNumber;
  }
  
  public void setBidNumber(int bidNumber) {
    this.bidNumber = bidNumber;
  }
  
  public int getBuyNowPrice() {
    return buyNowPrice;
  }
  
  public void setBuyNowPrice(int buyNowPrice) {
    this.buyNowPrice = buyNowPrice;
  }
  
}
