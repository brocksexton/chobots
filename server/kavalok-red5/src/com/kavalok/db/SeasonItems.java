package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class SeasonItems extends ModelBase {
	private Long id;
	private Integer season;
	private Integer tier;
	private Integer slot;
	private String rewardType;
	private String reward;
	private Boolean active;
	
	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getSeason() {
		return season;
	}

	public void setSeason(Integer season) {
		this.season = season;
	}
	
	public Integer getTier() {
		return tier;
	}

	public void setTier(Integer tier) {
		this.tier = tier;
	}
	
	public Integer getSlot() {
		return slot;
	}

	public void setSlot(Integer slot) {
		this.slot = slot;
	}
	
	public String getRewardType(){
		return rewardType;
	}

	public void setRewardType(String rewardType){
		this.rewardType = rewardType;
	}
	
	public String getReward(){
		return reward;
	}

	public void setReward(String reward){
		this.reward = reward;
	}

	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}
	
	public SeasonItems() {
		super();
	}
}
