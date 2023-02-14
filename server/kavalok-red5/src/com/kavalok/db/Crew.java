package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class Crew extends ModelBase {

	private User user;
	private Long user_id;
	private String userLogin;

	private Integer experience = 0;
	private Integer numCombats = 0;
	private Integer numWin = 0;
	private Integer color = 0;

	public Crew() {
		super();
	}

	public Crew(Long id) {
		super();
		this.setId(id);
	}

	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@NotNull
	public Integer getExperience() {
		return experience;
	}

	public void setExperience(Integer experience) {
		this.experience = experience;
	}

	@NotNull
	public Integer getNumCombats() {
		return numCombats;
	}

	public void setNumCombats(Integer numCombats) {
		this.numCombats = numCombats;
	}

	@NotNull
	public Integer getNumWin() {
		return numWin;
	}

	public void setNumWin(Integer numWin) {
		this.numWin = numWin;
	}

	@Column(unique = true, insertable = false, updatable = false)
	public Long getUser_id() {
		return user_id;
	}

	public void setUser_id(Long user_id) {
		this.user_id = user_id;
	}

	@NotNull
	public String getUserLogin() {
		return userLogin;
	}

	public void setUserLogin(String userLogin) {
		this.userLogin = userLogin;
	}

	@NotNull
	public Integer getColor() {
		return color;
	}

	public void setColor(Integer color) {
		this.color = color;
	}

}
