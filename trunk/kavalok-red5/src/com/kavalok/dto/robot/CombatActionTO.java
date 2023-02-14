package com.kavalok.dto.robot;


public class CombatActionTO {

	private String attackDirection = null;
	private String shieldDirection = null;
	private Integer specialItemId = null;
	
	public CombatActionTO() {
		super();
	}

	public String getAttackDirection() {
		return attackDirection;
	}

	public void setAttackDirection(String attackDirection) {
		this.attackDirection = attackDirection;
	}

	public String getShieldDirection() {
		return shieldDirection;
	}

	public void setShieldDirection(String shieldDirection) {
		this.shieldDirection = shieldDirection;
	}

	public Integer getSpecialItemId() {
		return specialItemId;
	}

	public void setSpecialItemId(Integer specialItemId) {
		this.specialItemId = specialItemId;
	}

}
