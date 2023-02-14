package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class Challenges extends ModelBase {
	private Long id;

	private String info;
	
	private Integer amountNeeded;
	
	private String charName;

	private Integer highestScore;
	
	private String type;
	
	private Integer active;
	
	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getAmountNeeded() {
		return amountNeeded;
	}

	public void setAmountNeeded(Integer amountNeeded) {
		this.amountNeeded = amountNeeded;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public String getCharName() {
		return charName;
	}

	public void setCharName(String charName) {
		this.charName = charName;
	}

	public Integer getHighestScore() {
		return highestScore;
	}

	public void setHighestScore(Integer highestScore) {
		this.highestScore = highestScore;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Integer getActive() {
		return active;
	}

	public void setActive(Integer active) {
		this.active = active;
	}

	
	public Challenges() {
		super();
	}
}
