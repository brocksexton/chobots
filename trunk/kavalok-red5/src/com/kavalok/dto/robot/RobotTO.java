package com.kavalok.dto.robot;

import java.util.List;

import com.kavalok.db.Robot;

public class RobotTO {
	
	private Long id;
	private String name;
	private Integer experience;
	private Boolean active;
	private List<RobotItemTO> items;
	private Integer level;
	private Integer energy;
	private String superCombination;
	
	public RobotTO() {
	}
	
	@SuppressWarnings("unchecked")
	public RobotTO(Robot robot, List<RobotItemTO> robotItems) {
		id = robot.getId();
		name = robot.getName();
		experience = robot.getExperience();
		active = robot.getActive();
		level = robot.getLevel();
		energy = robot.getEnergy();
		superCombination = robot.getSuperCombination();
		items = robotItems;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getExperience() {
		return experience;
	}

	public void setExperience(Integer experience) {
		this.experience = experience;
	}

	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}

	public List<RobotItemTO> getItems() {
		return items;
	}

	public void setItems(List<RobotItemTO> items) {
		this.items = items;
	}

	public Integer getEnergy() {
		return energy;
	}

	public void setEnergy(Integer energy) {
		this.energy = energy;
	}

	public String getSuperCombination() {
		return superCombination;
	}

	public void setSuperCombination(String superCombination) {
		this.superCombination = superCombination;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
}
