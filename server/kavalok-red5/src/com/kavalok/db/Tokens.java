package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class Tokens extends ModelBase {
	private Long id;

	private String code;

	private Integer count;
	
	private boolean available;

	private String claimedBy;

	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@NotNull
	@Column(unique = true)
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	 public Integer getCount() {
    	return count;
 	 }

  	public void setCount(Integer count) {
  		this.count = count;
 	 }

 	 public String getClaimedBy() {
 	 	return claimedBy;
 	 }

 	 public void setClaimedBy(String claimedBy){
 	 	this.claimedBy = claimedBy;
 	 }

	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isAvailable() {
		return available;
	}

	public void setAvailable(boolean available) {
		this.available = available;
	}


	public Tokens() {
		super();
	}

}
