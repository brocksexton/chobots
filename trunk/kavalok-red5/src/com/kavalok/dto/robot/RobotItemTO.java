package com.kavalok.dto.robot;

import java.util.Date;

import com.kavalok.db.Robot;
import com.kavalok.db.RobotItem;
import com.kavalok.db.RobotType;

public class RobotItemTO {
	
	private Long id;
	private Long robotId;
	private Integer color;
	private Integer position;

	private Integer level;
	private String name;
	private String robotName;
	private String placement;
	private Integer price;
	private Boolean premium;
	private Boolean hasColor;
	
	private Integer attack;
	private Integer defence;
	private Integer accuracy;
	private Integer mobility;
	
	private Integer energy;
	
	private Integer useCount;
	private Integer remains;
	private Integer lifeTime;
	private Date expirationDate;
	private String info;
	private Boolean percent;
	
	
	public RobotItemTO() {
	}

	public RobotItemTO(RobotItem item) {
		Robot robot = item.getRobot();
		RobotType type = item.getType();
		
		id = item.getId();
		robotId = (robot != null) ? robot.getId() : -1;
		color = item.getColor();
		position = item.getPosition();
		
		level = type.getLevel();
		name = type.getName();
		placement = type.getPlacement();
		price = type.getPrice();
		premium = type.getPremium();
		hasColor = type.getHasColor();
		
		attack = type.getAttack();
		defence = type.getDefence();
		accuracy = type.getAccuracy();
		mobility = type.getMobility();
		
		energy = type.getEnergy();
		
		useCount = type.getUseCount();
		remains = item.getRemains();
		lifeTime = type.getLifeTime();
		expirationDate = item.getExpirationDate();
		info = type.getInfo();
		robotName = type.getRobotName();
		percent = type.getPercent();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getRobotId() {
		return robotId;
	}

	public void setRobotId(Long robotId) {
		this.robotId = robotId;
	}

	public Integer getColor() {
		return color;
	}

	public void setColor(Integer color) {
		this.color = color;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPlacement() {
		return placement;
	}

	public void setPlacement(String placement) {
		this.placement = placement;
	}

	public Integer getPrice() {
		return price;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	public Boolean getPremium() {
		return premium;
	}

	public void setPremium(Boolean premium) {
		this.premium = premium;
	}

	public Boolean getHasColor() {
		return hasColor;
	}

	public void setHasColor(Boolean hasColor) {
		this.hasColor = hasColor;
	}

	public Integer getAttack() {
		return attack;
	}

	public void setAttack(Integer attack) {
		this.attack = attack;
	}

	public Integer getDefence() {
		return defence;
	}

	public void setDefence(Integer defence) {
		this.defence = defence;
	}

	public Integer getAccuracy() {
		return accuracy;
	}

	public void setAccuracy(Integer accuracy) {
		this.accuracy = accuracy;
	}

	public Integer getMobility() {
		return mobility;
	}

	public void setMobility(Integer mobility) {
		this.mobility = mobility;
	}

	public Integer getUseCount() {
		return useCount;
	}

	public void setUseCount(Integer useCount) {
		this.useCount = useCount;
	}

	public Date getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(Date expirationDate) {
		this.expirationDate = expirationDate;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public String getRobotName() {
		return robotName;
	}

	public void setRobotName(String robotName) {
		this.robotName = robotName;
	}

	public Integer getPosition() {
		return position;
	}

	public void setPosition(Integer position) {
		this.position = position;
	}

	public Integer getEnergy() {
		return energy;
	}

	public void setEnergy(Integer energy) {
		this.energy = energy;
	}

	public Boolean getPercent() {
		return percent;
	}

	public void setPercent(Boolean percent) {
		this.percent = percent;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public Integer getLifeTime() {
		return lifeTime;
	}

	public void setLifeTime(Integer lifeTime) {
		this.lifeTime = lifeTime;
	}

	public Integer getRemains() {
		return remains;
	}

	public void setRemains(Integer remains) {
		this.remains = remains;
	}
}
