package com.kavalok.dto.robot;


public class CombatResultTO {

	private Integer userId;
	private Boolean affected;
	private Boolean blocked;
	private Integer damage;
	private Integer repair;
	
	private String attackDirection;
	private Integer specialItemId;
	
	private Boolean finished = false;
	private Integer energy;
	private Integer experience;
	private Integer level;
	
	public CombatResultTO() {
		super();
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Boolean getAffected() {
		return affected;
	}

	public void setAffected(Boolean affected) {
		this.affected = affected;
	}

	public Boolean getBlocked() {
		return blocked;
	}

	public void setBlocked(Boolean blocked) {
		this.blocked = blocked;
	}

	public Integer getDamage() {
		return damage;
	}

	public void setDamage(Integer damage) {
		this.damage = damage;
	}

	public String getAttackDirection() {
		return attackDirection;
	}

	public void setAttackDirection(String attackDirection) {
		this.attackDirection = attackDirection;
	}

	public Integer getSpecialItemId() {
		return specialItemId;
	}

	public void setSpecialItemId(Integer specialItemId) {
		this.specialItemId = specialItemId;
	}

	public Boolean getFinished() {
		return finished;
	}

	public void setFinished(Boolean finished) {
		this.finished = finished;
	}

	public Integer getExperience() {
		return experience;
	}

	public void setExperience(Integer experience) {
		this.experience = experience;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public Integer getEnergy() {
		return energy;
	}

	public void setEnergy(Integer energy) {
		this.energy = energy;
	}

	public Integer getRepair() {
		return repair;
	}

	public void setRepair(Integer repair) {
		this.repair = repair;
	}

}
