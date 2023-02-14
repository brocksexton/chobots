package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
public class UserDance extends ModelBase {
	
	private String dance;

	public UserDance(String dance) {
		super();
		this.dance = dance;
	}
	
	public UserDance() {
		super();
	}

	@Column(length=1000)
	public String getDance() {
		return dance;
	}


	public void setDance(String dance) {
		this.dance = dance;
	}
	
}
