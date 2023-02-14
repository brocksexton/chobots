package com.kavalok.dao;

import com.kavalok.db.GameChar;
import com.kavalok.db.Mission;

import junit.framework.TestCase;

public class CharDAOTest extends TestCase {
	public void testAddMission() {
		GameChar gameChar = new CharDAO().getCharByName("mokus");
		Mission mission = new MissionDAO().getMission("Wheel");
		new CharDAO().addMission(gameChar, mission);
		gameChar = new CharDAO().getCharByName("mokus");
		boolean completed = false;
		for (Mission mission2 : gameChar.getCompletedMissions()) {
			if (mission2.getName().equals("Wheel")) {
				completed = true;
			}
		}
		assertTrue(completed);
	}

	public void testAddMoney() {
		GameChar gameChar = new CharDAO().getCharByName("mokus");
		long money = gameChar.getMoney();
		new CharDAO().addMoney(gameChar, 100);
		gameChar = new CharDAO().getCharByName("mokus");
		assertEquals(money + 100, gameChar.getMoney());
	}

}
