package com.kavalok.dto;

public class MoneyReportTO {
	
	private Double earned;
	private Double inviteesEarned;
	private Double bonus;
	
	public MoneyReportTO(Double earned, Double inviteesEarned, Double bonus) {
		super();
		this.earned = earned;
		this.inviteesEarned = inviteesEarned;
		this.bonus = bonus;
	}

	public Double getEarned() {
		return earned;
	}

	public void setEarned(Double earned) {
		this.earned = earned;
	}

	public Double getInviteesEarned() {
		return inviteesEarned;
	}

	public void setInviteesEarned(Double inviteesEarned) {
		this.inviteesEarned = inviteesEarned;
	}

	public Double getBonus() {
		return bonus;
	}

	public void setBonus(Double bonus) {
		this.bonus = bonus;
	}
	
	
}
