package com.kavalok.dto.robot;

import java.lang.reflect.InvocationTargetException;

import org.red5.io.utils.ObjectMap;

import com.kavalok.robots.RobotUtil;
import com.kavalok.utils.ReflectUtil;

public class RobotWrapper {
	
	private RobotTO robotTO;

	public RobotWrapper(RobotTO robotTO) {
		super();
		this.robotTO = robotTO;
	}
	
	public RobotTO getRobotTO() {
		return robotTO;
	}
	
	public Long getId() {
		return robotTO.getId();
	}
	
	public Integer getEnergy() {
		return robotTO.getEnergy();
	}

	public void setEnergy(Integer energy) {
		robotTO.setEnergy(energy);
	}
	
	public Integer getExperience() {
		return robotTO.getExperience();
	}

	public void setExperience(Integer experience) {
		robotTO.setExperience(experience);
	}
	
	public Integer getLevel() {
		return robotTO.getLevel();
	}
	
	public void setLevel(Integer level) {
		robotTO.setLevel(level);
	}
	
	// ------------------------------------------------- attack
	
	public int getAttack() {
		return getBaseAttack() + getAdditionalAttack();
	}
	
	public int getBaseAttack() {
		return calcBaseSum("attack");
	}
	
	public int getAdditionalAttack() {
		return calcArtifactSum("attack");
	}
	
	// ------------------------------------------------- defence
	
	public int getDefence() {
		return getBaseDefence() + getAdditionalDefence();
	}
	
	public int getBaseDefence() {
		return calcBaseSum("defence");
	}
	
	public int getAdditionalDefence() {
		return calcArtifactSum("defence");
	}
	
	// ------------------------------------------------- accuracy
	
	public int getAccuracy() {
		return getBaseAccuracy() + getAdditionalAccuracy();
	}
	
	public int getBaseAccuracy() {
		return calcBaseSum("accuracy");
	}
	
	public int getAdditionalAccuracy()
	{
		return calcArtifactSum("accuracy");
	}
	
	// ------------------------------------------------- mobility
	
	public int getMobility() {
		return getBaseMobility() + getAdditionalMobility();
	}
	
	public int getBaseMobility() {
		return calcBaseSum("mobility");
	}
	
	public int getAdditionalMobility() {
		return calcArtifactSum("mobility");
	}
	
	// ------------------------------------------------- energy
	 
	public int getMaxEnergy() {
		int baseSum = calcBaseSum("energy") + RobotUtil.getEnergy(robotTO.getLevel()); 
		double artifactSum = 0;
		
		for (RobotItemTO item : robotTO.getItems()) {
			if (isArtifact(item))
			{
				if (item.getPercent())
					artifactSum += baseSum * item.getEnergy() / 100.0;
				else
					artifactSum += item.getEnergy();
			}
		}
		
		return (int) (baseSum + artifactSum);
	}
	
	// -------------------------------------------------
	
	private boolean isArtifact(RobotItemTO item) {
		return item.getPlacement().equals(RobotTipes.ARTIFACT);
	}
	
	private boolean isSpecialItem(RobotItemTO item) {
		return item.getPlacement().equals(RobotTipes.SPECIAL_ITEM);
	}
	
	private boolean isBaceItem(RobotItemTO item) {
		return !isSpecialItem(item) && !isArtifact(item);
	}
	
	@SuppressWarnings("unused")
	private ObjectMap<String, String> getParameters(RobotItemTO item) {
		ObjectMap<String, String> result = new ObjectMap<String, String>();
		
		if (item.getInfo() != null) {
			String[] tokens = item.getInfo().split(";");
			for (int i=0; i<tokens.length; i++) {
				String token = tokens[i];
				String[] parts = token.split("=");
				if (parts.length == 2) {
					result.put(parts[0].trim(), parts[1].trim());
				}
			}
		}
		
		return result;
	}
	
	public RobotItemTO getItem(Integer itemId) {
		for (RobotItemTO item : robotTO.getItems()) {
			if (item.getId().equals(itemId.longValue())) {
				return item;
			}
		}
		return null;
	}
	// ------------------------------------------------- 
	
	private int getValue(RobotItemTO item, String property) {
		Integer result = 0;
		
		try {
			result = (Integer) ReflectUtil.callGetter(item, property);
		} catch (NoSuchMethodException e) {
		} catch (IllegalAccessException e) {
		} catch (InvocationTargetException e) {
		}

		return result;
	}
	
	private int calcBaseSum(String property) {
		int sum = 0;
		for (RobotItemTO item : robotTO.getItems()) {
			if (isBaceItem(item)) {
				sum += getValue(item, property);
			}
		}
		return sum;
	}
	
	private int calcArtifactSum(String property) {
		int baseSum = calcBaseSum(property);
		double sum = 0;
		for (RobotItemTO item : robotTO.getItems()) {
			if (isArtifact(item)) {
				if (item.getPercent()) {
					sum += baseSum * getValue(item, property) / 100.0;
				} else {
					sum += getValue(item, property);
				}
			}
		}
		return (int) sum;
	}
	
	
}
