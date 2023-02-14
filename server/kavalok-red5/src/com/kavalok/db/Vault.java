package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class Vault extends ModelBase {
	private Long id;
	private Integer code;
	private String prizeType;
	private Integer prize;
	private Integer claimedById;
	private Boolean enabled;
	
	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}
	
	public String getPrizeType(){
		return prizeType;
	}

	public void setPrizeType(String prizeType){
		this.prizeType = prizeType;
	}
	
	public Integer getPrize(){
		return prize;
	}

	public void setPrize(Integer prize){
		this.prize = prize;
	}
	
	public Integer getClaimedById(){
		return claimedById;
	}

	public void setClaimedById(Integer claimedById){
		this.claimedById = claimedById;
	}

	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	public Vault() {
		super();
	}
}
