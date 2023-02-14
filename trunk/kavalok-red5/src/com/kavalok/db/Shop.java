package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class Shop extends ModelBase {

	private String name;

	@NotNull
	@Column(unique = true)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
