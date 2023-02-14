package com.kavalok.dto.robot;


public class RobotSaveTO {
	
	private Long id;
	private Boolean active;
	
	public RobotSaveTO() {
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}
}
