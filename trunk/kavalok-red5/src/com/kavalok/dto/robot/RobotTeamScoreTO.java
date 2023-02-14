package com.kavalok.dto.robot;

import com.kavalok.db.RobotTeam;

public class RobotTeamScoreTO {

	private String name;
	private Integer color;
	private Integer numCombats;
	private Integer numWin;
	
	public RobotTeamScoreTO() {
		super();
	}

	public RobotTeamScoreTO(RobotTeam team) {
		this.name = team.getUserLogin();
		if(this.name ==null){
		  this.name = team.getUser().getLogin();
		}
		this.color = team.getColor();
		this.numCombats = team.getNumCombats();
		this.numWin = team.getNumWin();
	}

	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public Integer getNumWin() {
		return numWin;
	}


	public void setNumWin(Integer numWin) {
		this.numWin = numWin;
	}

	public Integer getNumCombats() {
		return numCombats;
	}

	public void setNumCombats(Integer numCombats) {
		this.numCombats = numCombats;
	}

	public Integer getColor() {
		return color;
	}

	public void setColor(Integer color) {
		this.color = color;
	}

}
