package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;
import java.util.Date;
import org.hibernate.validator.NotNull;

@Entity
public class MarketItems extends ModelBase {
	private Long id;
	private Boolean active;
	private Integer createdBy;
	private Integer itemId;
	private Integer currentBid;
	private Date createdDate;
	private Date endDate;
	private Integer buyerId;
	private Integer bidNumber;
	private Integer buyNowPrice;
	
	public MarketItems(Integer userId, Integer item, Integer startingBid, Integer hours, Integer buyNow) {
		super();
		this.active = true;
		this.createdBy = userId;
		this.itemId = item;
		this.currentBid = startingBid;
		this.createdDate = new Date();
		this.endDate = new Date(new Date().getTime() + (1000 * 60 * 60 * hours));
		this.buyerId = 0;
		this.bidNumber = 0;
		this.buyNowPrice = buyNow;
	}
	
	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}
	
	public Integer getItemId(){
		return itemId;
	}

	public void setItemId(Integer itemId){
		this.itemId = itemId;
	}
	
	public Integer getCurrentBid(){
		return currentBid;
	}

	public void setCurrentBid(Integer currentBid){
		this.currentBid = currentBid;
	}

	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
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

	public Integer getBuyerId(){
		return buyerId;
	}

	public void setBuyerId(Integer buyerId){
		this.buyerId = buyerId;
	}
	
	public Integer getBidNumber(){
		return bidNumber;
	}

	public void setBidNumber(Integer bidNumber){
		this.bidNumber = bidNumber;
	}
	
	public Integer getBuyNowPrice(){
		return buyNowPrice;
	}

	public void setBuyNowPrice(Integer buyNowPrice){
		this.buyNowPrice = buyNowPrice;
	}
	
	public MarketItems() {
		super();
	}
}
