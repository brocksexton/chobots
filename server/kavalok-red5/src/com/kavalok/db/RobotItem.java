package com.kavalok.db;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class RobotItem extends ModelBase {

	private RobotType type;
	private Robot robot;
	private User user;
	private Integer color = 0;
	private Integer position = 0;
	
	private Integer remains;
	private Date expirationDate;

	@NotNull
	@ManyToOne(fetch=FetchType.LAZY)
	public RobotType getType() {
		return type;
	}

	public void setType(RobotType type) {
		this.type = type;
	}

	@ManyToOne(fetch=FetchType.LAZY)
	public Robot getRobot() {
		return robot;
	}

	public void setRobot(Robot robot) {
		this.robot = robot;
	}

	@NotNull
	public Integer getColor() {
		return color;
	}

	public void setColor(Integer color) {
		this.color = color;
	}

	@NotNull
	@ManyToOne(fetch=FetchType.LAZY)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Date getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(Date expirationDate) {
		this.expirationDate = expirationDate;
	}

	@Column(nullable = false, columnDefinition = "int default 0")
	public Integer getPosition() {
		return position;
	}

	public void setPosition(Integer position) {
		this.position = position;
	}

	@Column(nullable = false, columnDefinition = "int default 0")
	public Integer getRemains() {
		return remains;
	}

	public void setRemains(Integer remains) {
		this.remains = remains;
	}


}
