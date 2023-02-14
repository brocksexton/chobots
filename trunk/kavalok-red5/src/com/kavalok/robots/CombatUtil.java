package com.kavalok.robots;

import com.kavalok.dto.robot.CombatActionTO;
import com.kavalok.dto.robot.CombatResultTO;
import com.kavalok.dto.robot.RobotItemTO;
import com.kavalok.dto.robot.RobotWrapper;

public class CombatUtil {
	
	static public void applyEnergy(CombatPlayer source, CombatPlayer target) {
		int energy = source.getRobot().getEnergy() + source.getResult().getRepair();
		energy = Math.min(energy, source.getRobot().getMaxEnergy());
		energy = Math.max(energy -target.getResult().getDamage(), 0); 
		source.getRobot().setEnergy(energy);
		source.getResult().setEnergy(energy);
	}
	
	static public void applyCombat(CombatPlayer source, CombatPlayer target) {
		
		CombatActionTO action = source.getAction();
		CombatResultTO result = new CombatResultTO();
		result.setUserId(source.getUserId().intValue());
		result.setAttackDirection(action.getAttackDirection());
		result.setSpecialItemId(action.getSpecialItemId());
		result.setDamage(0);
		result.setRepair(0);
		source.setResult(result);
		
		if (action.getAttackDirection() != null) {
			applyBaseAttack(source, target);
		} else if (action.getSpecialItemId() != -1) {
			applySpecialAttack(source, target);
			checkSpecialItem(source, action.getSpecialItemId());
		}
		
		source.setTotalDamage(source.getTotalDamage() + result.getDamage());
	}

	private static void checkSpecialItem(CombatPlayer source, Integer itemId) {
		RobotItemTO item = source.getRobot().getItem(itemId);
		if (item.getUseCount() > 0) {
			item.setRemains(item.getRemains() - 1);
			source.getUsedItems().put(itemId, item);
		}
	}

	private static void applyBaseAttack(CombatPlayer source, CombatPlayer target) {
		
		String attackDirection = source.getAction().getAttackDirection(); 
		String shieldDirection = target.getAction().getShieldDirection(); 
		
		int sourceAttack = source.getRobot().getAttack();
		int targetDefence = target.getRobot().getDefence();
		int randomAttack = getRandomAttack(sourceAttack,
				source.getRobot().getAccuracy(),
				target.getRobot().getMobility());
		
		int damage;
		boolean blocked;
		boolean affected = getAffected(source.getRobot(), target.getRobot());
		
		if (affected) {
			blocked = attackDirection.equals(shieldDirection);
			if (blocked) {
				damage = Math.max(randomAttack - targetDefence, 0);
			} else {
				damage = Math.max((int) (randomAttack - 0.2 * targetDefence), 0);
			}
		} else {
			damage = 0;
			blocked = false;
			affected = false;
		}
		
		source.getResult().setAffected(affected);
		source.getResult().setDamage(damage);
		source.getResult().setBlocked(blocked);
	}
	
	private static void applySpecialAttack(CombatPlayer source, CombatPlayer target) {
		
		Integer itemId = source.getAction().getSpecialItemId();
		RobotItemTO item = source.getRobot().getItem(itemId);
		
		int sourceAttack = 0;
		if (item.getAttack() > 0)
		{
			if (!item.getPercent())
				sourceAttack = item.getAttack();
			else
				sourceAttack = (int) (target.getRobot().getMaxEnergy() * item.getAttack() / 100.0);
		}
		
		int targetDefence = target.getRobot().getDefence();
		int randomAttack = getRandomAttack(sourceAttack,
				source.getRobot().getAccuracy(),
				target.getRobot().getMobility());
		
		int damage;
		boolean affected = getAffected(source.getRobot(), target.getRobot());
		
		if (affected) {
			damage = Math.max((int) (randomAttack - 0.3 * targetDefence), 0);
		} else {
			damage = 0;
		}
		
		if (item.getEnergy() > 0) {
			int repair = item.getPercent()
				? (int) (source.getRobot().getMaxEnergy() * item.getEnergy() / 100.0)
				: item.getEnergy().intValue();
			source.getResult().setRepair(repair);
		}
		
		source.getResult().setAffected(affected);
		source.getResult().setDamage(damage);
		source.getResult().setBlocked(false);
	}
	
	private static int getRandomAttack(int baseAttack, int accuracy, int targetMobility) {
		double koef = (double) targetMobility / (1 + accuracy);
		double varAttack = Math.min(baseAttack * Math.min(koef, 1), 0.5 * baseAttack);
		int result = (int) (baseAttack - Math.random() * varAttack);
		return result;
	}
	
	private static boolean getAffected(RobotWrapper source, RobotWrapper target) {
		double koef = (double) target.getMobility() / (1 + source.getAccuracy());
		double affectProbability = Math.max(1 - Math.min(0.2 * koef, 1), 0.4);
		double probability = Math.random(); 
		return probability < affectProbability;
	}
}
