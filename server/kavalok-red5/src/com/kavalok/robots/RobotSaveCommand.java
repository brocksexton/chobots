package com.kavalok.robots;

import java.util.Collection;
import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.RobotDAO;
import com.kavalok.dao.RobotItemDAO;
import com.kavalok.db.Robot;
import com.kavalok.db.RobotItem;
import com.kavalok.db.User;
import com.kavalok.dto.robot.RobotItemSaveTO;
import com.kavalok.dto.robot.RobotSaveTO;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class RobotSaveCommand {

	private Collection<RobotSaveTO> robotsData;
	private Collection<RobotItemSaveTO> itemsData;
	private Session session;
	RobotDAO robotDAO;
	RobotItemDAO itemDAO;
	List<Robot> robots;
	List<RobotItem> items;

	public RobotSaveCommand(Session session,
			Collection<RobotSaveTO> robotsData,
			Collection<RobotItemSaveTO> itemsData) {
		super();
		this.session = session;
		this.robotsData = robotsData;
		this.itemsData = itemsData;
	}

	public void execute() {
		UserAdapter adapter = UserManager.getInstance().getCurrentUser();
		User user = new User(adapter.getUserId());
		robotDAO = new RobotDAO(session);
		itemDAO = new RobotItemDAO(session);
		robots = robotDAO.findByUser(user);
		items = itemDAO.findByUser(user);

		saveRobots();
		saveItems();
	}

	private void saveRobots() {
		Boolean activeAssigned = false;
		for (Robot robot : robots) {
			RobotSaveTO robotData = findRobotSaveTO(robot.getId());
			if (robotData == null) {
				continue;
			}
			Boolean active = false;
			if (robotData.getActive() && !activeAssigned) {
				active = true;
				activeAssigned = true;
			}
			if (!robot.getActive().equals(active)) {
				robot.setActive(active);
				robotDAO.makePersistent(robot);
			}
		}
	}

	private void saveItems() {
		for (RobotItem item : items) {
			RobotItemSaveTO itemData = findItemSaveTO(item.getId());
			if (itemData == null) {
				continue;
			}
			Robot currentRobot = findRobot(itemData.getRobotId());

			boolean changed = false;
			if (item.getRobot() == null && currentRobot == null) {
				changed = false;
			} else if (item.getRobot() != null || currentRobot != null) {
				changed = true;
			} else {
				changed = !item.getRobot().getId().equals(currentRobot.getId())
						|| !item.getPosition().equals(itemData.getPosition());
			}

			if (changed) {
				item.setRobot(currentRobot);
				item.setPosition(itemData.getPosition());
				itemDAO.makePersistent(item);

				if (currentRobot != null) {
					forceItems(item, currentRobot);
				}
			}
		}
	}

	private void forceItems(RobotItem currentItem, Robot currentRobot) {
		for (RobotItem item: items) {
			if (item.getRobot() == null || item.getId().equals(currentItem.getId())) {
				continue;
			}
			if (!item.getType().getId().equals(currentItem.getType().getId())) {
				continue;
			}
			if (!item.getRobot().getId().equals(currentRobot.getId())) {
				continue;
			}
			item.setRobot(null);
			itemDAO.makePersistent(item);
		}
	}

	private RobotSaveTO findRobotSaveTO(Long id) {
		for (RobotSaveTO item : robotsData) {
			if (item.getId().equals(id)) {
				return item;
			}
		}
		return null;
	}

	private Robot findRobot(Long robotId) {
		if (robotId.equals(-1)) {
			return null;
		}
		for (Robot item : robots) {
			if (item.getId().equals(robotId)) {
				return item;
			}
		}
		return null;
	}

	private RobotItemSaveTO findItemSaveTO(Long itemId) {
		for (RobotItemSaveTO item : itemsData) {
			if (item.getId().equals(itemId)) {
				return item;
			}
		}
		return null;
	}

}
