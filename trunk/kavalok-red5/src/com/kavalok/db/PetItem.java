package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class PetItem extends ModelBase {

	private String name;
	private String placement;
	private int price = 1;

	@NotNull
	@Column(unique = true)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(columnDefinition = "varchar(10) not null")
	public String getPlacement() {
		return placement;
	}

	public void setPlacement(String placement) {
		this.placement = placement;
	}

	@NotNull
	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

}
