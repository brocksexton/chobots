package com.kavalok.robots;

import org.red5.io.utils.ObjectMap;

import com.kavalok.dto.CharTO;
import com.kavalok.dto.robot.CombatActionTO;
import com.kavalok.dto.robot.CombatResultTO;
import com.kavalok.dto.robot.RobotItemTO;
import com.kavalok.dto.robot.RobotWrapper;

public class CombatPlayer {

	private Long userId;
	private CharTO user;
	private RobotWrapper robot;
	private CombatActionTO action;
	private CombatResultTO result;
	private boolean ready = false;
	private ObjectMap<Integer, RobotItemTO>	usedItems;
	private int totalDamage = 0;
	
	public CombatPlayer(Long userId) {
		super();
		this.usedItems = new ObjectMap<Integer, RobotItemTO>();
		this.userId = userId;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public RobotWrapper getRobot() {
		return robot;
	}

	public void setRobot(RobotWrapper robot) {
		this.robot = robot;
	}

	public CombatActionTO getAction() {
		return action;
	}

	public void setAction(CombatActionTO action) {
		this.action = action;
	}

	public CharTO getUser() {
		return user;
	}

	public void setUser(CharTO user) {
		this.user = user;
	}

	public CombatResultTO getResult() {
		return result;
	}

	public void setResult(CombatResultTO result) {
		this.result = result;
	}

	public ObjectMap<Integer, RobotItemTO> getUsedItems() {
		return usedItems;
	}

	public void setUsedItems(ObjectMap<Integer, RobotItemTO> usedItems) {
		this.usedItems = usedItems;
	}

	public boolean isReady() {
		return ready;
	}

	public void setReady(boolean ready) {
		this.ready = ready;
	}

	public int getTotalDamage() {
		return totalDamage;
	}

	public void setTotalDamage(int totalDamage) {
		this.totalDamage = totalDamage;
	}

}
