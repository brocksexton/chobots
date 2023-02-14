package com.kavalok.dto.robot;

import com.kavalok.db.Robot;

public class RobotScoreTO {

	private String name;
	private Integer level;
	private Integer numCombats;
	private Integer numWin;
	
	public RobotScoreTO() {
		super();
	}

	public RobotScoreTO(Robot robot) {
		this.name = robot.getUserLogin();
		if(this.name ==null){
		  this.name = robot.getUser().getLogin();
		}
		this.level = robot.getLevel();
		this.numCombats = robot.getNumCombats();
		this.numWin = robot.getNumWin();
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

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

}
