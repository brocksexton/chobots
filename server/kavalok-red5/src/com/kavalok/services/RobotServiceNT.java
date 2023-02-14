package com.kavalok.services;

import java.util.ArrayList;
import java.util.List;

import org.red5.io.utils.ObjectMap;
import org.red5.server.api.so.ISharedObject;

import com.kavalok.KavalokApplication;
import com.kavalok.dao.RobotDAO;
import com.kavalok.dao.RobotItemDAO;
import com.kavalok.dao.RobotTeamDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.Robot;
import com.kavalok.db.RobotItem;
import com.kavalok.db.User;
import com.kavalok.dto.CharTO;
import com.kavalok.dto.robot.RobotItemTO;
import com.kavalok.dto.robot.RobotScoreTO;
import com.kavalok.dto.robot.RobotTO;
import com.kavalok.dto.robot.RobotTeamScoreTO;
import com.kavalok.robots.CombatPlayer;
import com.kavalok.robots.RobotUtil;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.sharedObjects.CombatListener;
import com.kavalok.sharedObjects.SOListener;
import com.kavalok.utils.ReflectUtil;

public class RobotServiceNT extends DataServiceNotTransactionBase {

	public RobotItemTO getItem(Integer itemId) {
		RobotItemDAO dao = new RobotItemDAO(getSession());
		return new RobotItemTO(dao.findById(itemId.longValue()));
	}

	@SuppressWarnings("unchecked")
	public List<RobotScoreTO> getTopScores() {
		RobotDAO robotDAO = new RobotDAO(getSession());
		List<Robot> robots = robotDAO.getScoreTable(100);
		List<RobotScoreTO> result = ReflectUtil.convertBeansByConstructor(
				robots, RobotScoreTO.class);
		
		User user = new User(getAdapter().getUserId());
		Robot activeRobot = robotDAO.getActiveRobot(user);
		
		if (activeRobot != null) {
			result.add(new RobotScoreTO(activeRobot));
		} else {
			result.add(null);
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	public List<RobotTeamScoreTO> getTeamTopScores() {
		RobotTeamDAO teamDAO = new RobotTeamDAO(getSession());
		List<Robot> robots = teamDAO.getScoreTable(50);
		List<RobotTeamScoreTO> result = ReflectUtil.convertBeansByConstructor(
				robots, RobotTeamScoreTO.class);
		
		User user = new UserDAO(getSession()).findById(getAdapter().getUserId());
		if (user.getRobotTeam() != null) {
			result.add(new RobotTeamScoreTO(user.getRobotTeam()));
		} else {
			result.add(null);
		}
		return result;
	}
	
	public ObjectMap<String, Object> getCombatData(String soId) {
		ISharedObject sharedObject = KavalokApplication.getInstance()
				.getSharedObject(soId);
		CombatListener combat = (CombatListener) SOListener
				.getListener(sharedObject);

		ArrayList<CharTO> users = new ArrayList<CharTO>();
		ArrayList<RobotTO> robots = new ArrayList<RobotTO>();

		for (CombatPlayer player : combat.getPlayers().values()) {
			users.add(player.getUser());
			robots.add(player.getRobot().getRobotTO());
		}

		ObjectMap<String, Object> result = new ObjectMap<String, Object>();
		result.put("users", users);
		result.put("robots", robots);

		return result;
	}

	@SuppressWarnings("unchecked")
	public List<RobotItemTO> getAllItems() {
		User user = new User(getAdapter().getUserId());
		List<RobotItem> items = new RobotItemDAO(getSession()).findByUser(user);
		List<RobotItemTO> result = ReflectUtil.convertBeansByConstructor(items,
				RobotItemTO.class);

		return result;
	}

	public List<RobotTO> getRobotsLite() {
		User user = new User(getAdapter().getUserId());
		List<Robot> robots = new RobotDAO(getSession()).findByUser(user);
		List<RobotTO> result = new ArrayList<RobotTO>();
		for (Robot robot : robots) {
			RobotTO robotTO = new RobotTO(robot, null);
			result.add(robotTO);
		}
		return result;
	}

	public RobotTO getCharRobot(Integer userId) {
		return RobotUtil.getCharRobot(getSession(), userId);
	}
}
