package com.kavalok.dto.robot;


public class RobotItemSaveTO {
	
	private Long id;
	private Long robotId;
	private Integer position;
	
	public RobotItemSaveTO() {
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

	public Integer getPosition() {
		return position;
	}

	public void setPosition(Integer position) {
		this.position = position;
	}

}
