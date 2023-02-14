package com.kavalok.robots;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.GameCharDAO;
import com.kavalok.dao.RobotDAO;
import com.kavalok.dao.RobotTeamDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.Robot;
import com.kavalok.db.RobotTeam;
import com.kavalok.db.User;
import com.kavalok.dto.CharTOCache;
import com.kavalok.user.UserManager;

public class TeamUtil {
	
	private Session session;
	private UserDAO userDAO;
	private RobotTeamDAO teamDAO;
	private RobotDAO robotDAO;
	private User currentUser;

	public TeamUtil(Session session) {
		super();
		this.session = session;
		this.userDAO = new UserDAO(session);
		this.robotDAO = new RobotDAO(session);
		this.teamDAO = new RobotTeamDAO(session);
		this.currentUser = userDAO.findById(UserManager.getInstance().getCurrentUser().getUserId());
	}
	
	public void createTeam(Integer color)
	{
        GameCharDAO charDAO = new GameCharDAO(session); 
    	GameChar gameChar = charDAO.findByUserId(currentUser.getId());
        if (gameChar.getMoney() < RobotConstants.TEAM_PRICE) {
            throw new IllegalStateException("Char doesn't have enough money");
        }
        
        // remove from currentTeam
		RobotTeam currentTeam = currentUser.getRobotTeam();
		if (currentTeam != null) {
			substractParameters(currentUser, currentTeam);
			teamDAO.makePersistent(currentTeam);
		}
        
		// create team
	    RobotTeam team = teamDAO.findByUser(currentUser);
		if (team == null) {
	    	team = new RobotTeam();
	    	team.setUser(currentUser);
	    	team.setUserLogin(currentUser.getLogin());
	    } else {
	    	resetTeam(team);
	    }
	    addParameters(currentUser, team);
    	team.setColor(color);
    	teamDAO.makePersistent(team);
    	
        assignToTeam(currentUser, team);
        userDAO.makePersistent(currentUser);
	}
	
	public void addToTeam(Integer ownerId) {
		User owner = new User(ownerId.longValue());
		RobotTeam team = teamDAO.findByUser(owner);
		if (team == null) {
			return;
		}
		
		// check team limit
		List<User> members = userDAO.findByRobotTeam(team);
		if (members.size() >= RobotConstants.TEAM_LIMIT) {
	        throw new IllegalStateException("Team is full");
		}
		
		// remove from currentTeam
		RobotTeam currentTeam = currentUser.getRobotTeam();
		if (currentTeam != null)
		{
			if (currentTeam.getUser_id().equals(currentUser.getId())) {
				resetTeam(currentTeam);
				teamDAO.makeTransient(currentTeam);
			} else {
				substractParameters(currentUser, currentTeam);
				teamDAO.makePersistent(currentTeam);
			}
		}
		
		// add user
		addParameters(currentUser, team);
		teamDAO.makePersistent(team);
		
		assignToTeam(currentUser, team);
		userDAO.makePersistent(currentUser);
	}
	
	public void removeFromTeam(Integer userId) {
		RobotTeam currentTeam = currentUser.getRobotTeam();
		if (currentTeam != null) {
			User user = userDAO.findById(userId.longValue());
			if (user.getRobotTeam_id().equals(currentTeam.getId())) {
				substractParameters(user, currentTeam);
				teamDAO.makePersistent(currentTeam);
				assignToTeam(user, null);
				userDAO.makePersistent(user);
			}
		}
	}
	
	private void addParameters(User user, RobotTeam team) {
		List<Robot> robots = robotDAO.findByUser(user);
		for (Robot robot: robots) {
			team.setExperience(team.getExperience() + robot.getExperience());
			team.setNumCombats(team.getNumCombats() + robot.getNumCombats());
			team.setNumWin(team.getNumWin() + robot.getNumWin());
		}
	}
	
	private void substractParameters(User user, RobotTeam team) {
		List<Robot> robots = robotDAO.findByUser(user);
		for (Robot robot: robots) {
			team.setExperience(team.getExperience() - robot.getExperience());
			team.setNumCombats(team.getNumCombats() - robot.getNumCombats());
			team.setNumWin(team.getNumWin() - robot.getNumWin());
		}
	}
	
	private void resetTeam(RobotTeam team) {
    	List<User> members = userDAO.findByRobotTeam(team);
    	for (User member: members) {
    		assignToTeam(member, null);
    		userDAO.makePersistent(member);
    	}
    	team.setExperience(0);
    	team.setNumCombats(0);
    	team.setNumWin(0);
	}
	
	private void assignToTeam(User user, RobotTeam team)
	{
        CharTOCache.getInstance().removeCharTO(user.getId());
        CharTOCache.getInstance().removeCharTO(user.getLogin());
		user.setRobotTeam(team);
	}

}
