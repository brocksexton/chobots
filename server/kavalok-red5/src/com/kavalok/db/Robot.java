package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class Robot extends ModelBase {

  //update Robot r, User u set userLogin = login where r.user_id=u.id
  
	private User user;
  private Long user_id;
  private String userLogin;
	
	private String name;
	private Integer level;
	private Integer experience = 0;
	private Integer energy = 0;
	private String superCombination = "";
	private Boolean active = false;
	private Integer numCombats = 0;
	private Integer numWin = 0;
	
	public Robot() {
		super();
	}

	public Robot(Long id) {
		super();
		this.setId(id);
	}
	
	@NotNull
	@ManyToOne(fetch=FetchType.LAZY)
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
	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}

	@NotNull
	public Integer getEnergy() {
		return energy;
	}

	public void setEnergy(Integer energy) {
		this.energy = energy;
	}

	
	@NotNull
	@Column(length = 5)
	public String getSuperCombination() {
		return superCombination;
	}

	public void setSuperCombination(String superCombination) {
		this.superCombination = superCombination;
	}

	@NotNull
	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	@NotNull
	@Column(length = 15)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(nullable = false, columnDefinition = "int default 0")
	public Integer getNumCombats() {
		return numCombats;
	}

	public void setNumCombats(Integer numCombats) {
		this.numCombats = numCombats;
	}

	@Column(nullable = false, columnDefinition = "int default 0")
	public Integer getNumWin() {
		return numWin;
	}

	public void setNumWin(Integer numWin) {
		this.numWin = numWin;
	}

	@Column(insertable=false, updatable=false)
  public Long getUser_id() {
    return user_id;
  }

  public void setUser_id(Long user_id) {
    this.user_id = user_id;
  }

  public String getUserLogin() {
    return userLogin;
  }

  public void setUserLogin(String userLogin) {
    this.userLogin = userLogin;
  }

}
