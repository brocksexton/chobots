package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class RobotType extends ModelBase {

	private String name;
	private String robotName;
	private String placement;
	private String catalog;
	
	private Integer level;
	private Integer lifeTime;
	private Integer useCount;
	private Integer energy;
	
	private Integer attack;
	private Integer defence;
	private Integer accuracy;
	private Integer mobility;
	
	private Integer price;
	private Boolean premium;
	private Boolean hasColor;
	private String info;
	private Boolean percent;
	
	public RobotType() {
    super();
  }
	
	public RobotType(Long id) {
    super();
    setId(id);
  }

	@Column(nullable=false, length=15)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@NotNull
	public Integer getAttack() {
		return attack;
	}

	public void setAttack(Integer attack) {
		this.attack = attack;
	}

	@NotNull
	public Integer getDefence() {
		return defence;
	}

	public void setDefence(Integer defence) {
		this.defence = defence;
	}

	@NotNull
	public Integer getAccuracy() {
		return accuracy;
	}

	public void setAccuracy(Integer accuracy) {
		this.accuracy = accuracy;
	}

	@NotNull
	public Integer getMobility() {
		return mobility;
	}

	public void setMobility(Integer mobility) {
		this.mobility = mobility;
	}

	@Column(nullable=false, length=3)
	public String getPlacement() {
		return placement;
	}

	public void setPlacement(String placement) {
		this.placement = placement;
	}

	@Column(nullable=false, length=25)
	public String getCatalog() {
		return catalog;
	}

	public void setCatalog(String catalog) {
		this.catalog = catalog;
	}

	@NotNull
	public Integer getPrice() {
		return price;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	@NotNull
	public Boolean getPremium() {
		return premium;
	}

	public void setPremium(Boolean premium) {
		this.premium = premium;
	}

	@NotNull
	public Boolean getHasColor() {
		return hasColor;
	}

	public void setHasColor(Boolean hasColor) {
		this.hasColor = hasColor;
	}

	@NotNull
	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	@NotNull
	public Integer getLifeTime() {
		return lifeTime;
	}

	public void setLifeTime(Integer lifeTime) {
		this.lifeTime = lifeTime;
	}

	@NotNull
	public Integer getUseCount() {
		return useCount;
	}

	public void setUseCount(Integer useCount) {
		this.useCount = useCount;
	}

	@NotNull
	public Integer getEnergy() {
		return energy;
	}

	public void setEnergy(Integer energy) {
		this.energy = energy;
	}

	@NotNull
	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}
	
	@Column(nullable = false, length = 15)
	public String getRobotName() {
		return robotName;
	}

	public void setRobotName(String robotName) {
		this.robotName = robotName;
	}

	@Column(nullable = false, columnDefinition = "boolean default false")
	public Boolean getPercent() {
		return percent;
	}

	public void setPercent(Boolean percent) {
		this.percent = percent;
	}

}
