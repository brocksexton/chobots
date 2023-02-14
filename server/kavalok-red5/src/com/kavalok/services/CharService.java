package com.kavalok.services;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.text.SimpleDateFormat;

import com.kavalok.db.*;
import com.kavalok.dao.ChallengesDAO;
import com.kavalok.xmlrpc.RemoteClient;
import org.apache.commons.beanutils.BeanUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.red5.io.utils.ObjectMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.primitives.Ints;

import com.kavalok.KavalokApplication;
import com.kavalok.dao.BanDAO;
import com.kavalok.dao.GameCharDAO;
import com.kavalok.dao.MembershipInfoDAO;
import com.kavalok.dao.MessageDAO;
import com.kavalok.dao.PetDAO;
import com.kavalok.dao.QueriesNames;
import com.kavalok.dao.QuestDAO;
import com.kavalok.dao.RobotDAO;
import com.kavalok.dao.StuffItemDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.dao.BestFriendsDAO;
import com.kavalok.dao.UserDanceDAO;
import com.kavalok.dao.UserServerDAO;
import com.kavalok.dao.statistics.LoginStatisticsDAO;
import com.kavalok.dto.CharTO;
import com.kavalok.dto.CharTOCache;
import com.kavalok.dto.GameEnterTO;
import com.kavalok.dao.ClientErrorDAO;
import com.kavalok.dto.KeysTO;
import com.kavalok.dto.MoneyReportTO;
import com.kavalok.dto.friend.FriendTO;
import com.kavalok.dto.home.CharHomeTO;
import com.kavalok.dto.pet.PetTO;
import com.kavalok.dto.stuff.StuffItemLightTO;
import com.kavalok.dto.stuff.StuffTypeTO;
import com.kavalok.messages.ServersCache;
import com.kavalok.robots.RobotUtil;
import com.kavalok.services.common.DataServiceBase;
import com.kavalok.services.stuff.StuffTypes;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;
import com.kavalok.user.UserUtil;
import com.kavalok.utils.DateUtil;
import com.kavalok.utils.StringUtil;
import com.kavalok.utils.ReflectUtil;
import java.util.TimeZone;

public class CharService extends DataServiceBase {

    private static final String GIFT_CLASS_NAME = "com.kavalok.messenger.commands::GiftMessage";

    private static final int DANCES_COUNT = 3;

    private static final Long ONE_DAY_SECONDS = Long.parseLong("86400");

    private static final Logger logger = LoggerFactory.getLogger(CharService.class);

    private static Object friendSynchronizer = new Object();

    private UserAdapter userAdmin = UserManager.getInstance().getCurrentUser();

    public int getLastOnlineDay(Integer userId) {
        User user = new UserDAO(getSession()).findById(userId.longValue());
        if (user == null) {
            return 10000;
        }
        Date lastDate = new LoginStatisticsDAO(getSession()).getLastOnlineDate(user);
        if (lastDate == null) {
            return 10000;
        }
        int day = (int) (new Date().getTime() - lastDate.getTime()) / 1000 / 3600 / 24;

        return day;
    }

    // returns:
    // s = success
    // f = unknown fail
    // nc = not citizen
    // ac = already claimed, wait another 24 hours
    // na = new account
    // m = isMod
    // pBb = processbonusbugs
    // ps = processspin
    public String pBb()
    {
        UserDAO userDAO = new UserDAO(getSession());
        User dUser = userDAO.findByLogin(userAdmin.getLogin());
        UserExtraInfo uei = dUser.getUserExtraInfo();

        String errMessage = "f";

        //if(dUser.isModerator())
          //  return "m";

        //String lastBugsAwardDate = uei.getLastAwardBugsDate();

        //int loginDays = uei.getContinuousDaysLoginCount();

        //int addBugs = 1000 + (loginDays * 2);

        Boolean status = false;

       // if(lastBugsAwardDate == "" || lastBugsAwardDate == "NULL" || lastBugsAwardDate == null || lastBugsAwardDate == "0")
       //     status = true;

       // Long creationDate = dUser.getCreated().getTime() / 1000; // creationdate in seconds, not miliseconds
        //Long currentDate = new Date().getTime() / 1000;

      //  if(!dUser.isCitizen())
       // {
         //   errMessage = "nc";
          //  return errMessage;
        //}


        // user might have been awarded bugs already
        //if(status == false && currentDate > Long.parseLong(lastBugsAwardDate) + ONE_DAY_SECONDS ) {
           // System.out.println("been over a day since last award date.. awarding.. :  orig: " + Long.parseLong(lastBugsAwardDate)
           // + " new: "+ currentDate);
        //    status = true;
        //} 

        //if(creationDate + ONE_DAY_SECONDS > currentDate){
         //   status = false;
        //    errMessage = "na";

        //    System.out.println(" creationDate = "+creationDate + "  currentDate = "+ currentDate);
        //    return errMessage;
        //}

        //if(status) {
        //    giveExtraBugs(addBugs);
        //    uei.setLastAwardBugsDate(Long.toString(new Date().getTime() / 1000));
			
        //    if(uei.getContinuousDaysLoginCount() >= 50)
        //    {
        //        uei.setContinuousDaysLoginCount(1);
        //    }
		//	new UserUtil().addCrowns(getSession(), userAdmin.getUserId(), 5);
            //sendUserTeamMessage("Congratulations! You've received " + addBugs + " bugs for logging in " + loginDays + " day(s) in a row! Login tomorrow for more!");
		//	new RemoteClient(getSession(), dUser).sendCommand("DialogDailyCommand", Integer.toString(addBugs));
        //}

        return (status) ? "s" : errMessage;
    }
	
	 public Integer getCharSpin()
    {
        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findByLogin(userAdmin.getLogin());
        UserExtraInfo uei = user.getUserExtraInfo();
		
        String errMessage = "f";

		String lastSpinDate = uei.getLastSpinDate();
	
        Boolean status = false;

        if(lastSpinDate == "" || lastSpinDate == "NULL" || lastSpinDate == null || lastSpinDate == "0")
            status = true;
		
        Long creationDate = user.getCreated().getTime() / 1000; // creationdate in seconds, not miliseconds
        Long currentDate = new Date().getTime() / 1000;

        if(status == false && currentDate > Long.parseLong(lastSpinDate) + ONE_DAY_SECONDS ) {
            System.out.println("been over a day since last award date.. awarding.. ");
           // + " new: "+ currentDate);
            status = true;
        }

        if(creationDate + ONE_DAY_SECONDS > currentDate){
            status = false;
            errMessage = "na";

            System.out.println(" creationDate = "+creationDate + "  currentDate = "+ currentDate);
        }
		
        if(status) {
            uei.setLastSpinDate(Long.toString(new Date().getTime() / 1000));
			Integer newSpins = uei.getSpins() + 1;
			uei.setSpins(newSpins);
            sendUserTeamMessage("Congratulations! You've received a free spin for logging in today! Login tomorrow for more!");
		} 
		
        return uei.getSpins();
    }

    private int getMultiplierBugBonus()
    {
        UserDAO userDAO = new UserDAO(getSession());
        User dUser = userDAO.findByLogin(userAdmin.getLogin());

        if(dUser.isCitizen())
            return 20;

        return 10; // non citizen

    }

    private void sendUserTeamMessage(String reason)
    {

        User user = new UserDAO(getSession()).findById(userAdmin.getUserId().longValue());
        GameChar gameChar = user.getGameChar();

        ObjectMap<String, Object> command = new ObjectMap<String, Object>();
        command.put("className", "com.kavalok.messenger.commands.MailMessage");
        command.put("sender", "UTM20");
        command.put("text", reason);
        command.put("dateTime", new Date());

        Message msg = new Message(gameChar, command);
        MessageDAO messageDAO = new MessageDAO(getSession());
        Long messId = messageDAO.makePersistent(msg).getId();
        command.put("id", messId);

        new RemoteClient(getSession(), user).sendCommand(command);
    }

	private void sendAchievementMessage(String reason)
    {

        User user = new UserDAO(getSession()).findById(userAdmin.getUserId().longValue());
        GameChar gameChar = user.getGameChar();

        ObjectMap<String, Object> command = new ObjectMap<String, Object>();
        command.put("className", "com.kavalok.messenger.commands.MailMessage");
        command.put("sender", "UTM20");
        command.put("text", reason);
        command.put("dateTime", new Date());

        Message msg = new Message(gameChar, command);
        MessageDAO messageDAO = new MessageDAO(getSession());
        Long messId = messageDAO.makePersistent(msg).getId();
        command.put("id", messId);

        new RemoteClient(getSession(), user).sendCommand(command);
    }
	
    //private void giveExtraBugs(int bugs)
    //{
    //    UserDAO userDAO = new UserDAO(getSession());
    //    User dUser = userDAO.findByLogin(userAdmin.getLogin());
    //    UserExtraInfo uei = dUser.getUserExtraInfo();

    //    System.out.println("adding bugs " + bugs + " to user: "+ dUser.getLogin());

        // how do we add, do we directly interact with gamechar?
    //    userAdmin.addMoney(getSession(), bugs, "Daily bug reward");
    //}

    public Boolean isAuthorizedBody() {
        if (userAdmin.isBoughtBody()) {

            return true;
        } else {
            userAdmin.goodBye("Hacking attempt detected", false);
            return false;
        }
    }

    public void saveSettings(Integer musicVolume, Integer soundVolume, Boolean acceptRequests, Boolean acceptNight, Boolean showTips,
                             Boolean showCharNames, Boolean publicLocation, Integer uiColler, Boolean defaultFrame) {

        UserDAO userDAO = new UserDAO(getSession());
        UserAdapter userAdapter = UserManager.getInstance().getCurrentUser();
        if (!userAdapter.getPersistent()) {
            return;
        }
		Date currentTime = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("HH");
		sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
		int hour = Integer.parseInt(sdf.format(currentTime));
		
        User user = userDAO.findById(userAdapter.getUserId());
        user.setMusicVolume(musicVolume);
        user.setSoundVolume(soundVolume);
        user.setPublicLocation(publicLocation);
        user.setAcceptRequests(acceptRequests);
        user.setAcceptNight(acceptNight);
		if(acceptNight && (hour >= 21 || hour <= 5)) {
			new RemoteClient(getSession(), user).sendCommand("NightMode", null);
		} else {
			new RemoteClient(getSession(), user).sendCommand("NightOffMode", null);
		}
		
        user.setShowTips(showTips);
        user.setDefaultFrame(defaultFrame);
        user.setUIColour(uiColler);
        userDAO.makePersistent(user);
        GameChar gameChar = user.getGameChar();
        gameChar.setShowCharNames(showCharNames);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

    public MoneyReportTO getMoneyReport() {
        GameChar gameChar = new GameCharDAO(getSession()).findByUserId(getAdapter().getUserId());
        return new MoneyReportTO(gameChar.getTotalMoneyEarned(), gameChar.getTotalMoneyEarnedByInvites(), gameChar
                .getTotalBonusMoney());
    }
	
	public GameEnterTO refreshStuffs(String charName) {
	GameEnterTO result = new GameEnterTO();
	UserDAO userDAO = new UserDAO(getSession());
	User user = userDAO.findByLogin(charName);
    GameChar gameChar = user.getGameChar();
    List<StuffItem> charClothesAndStuffs = getCharClothesAndStuffs(user, gameChar, !user.isCitizen(), false);
    List<StuffItemLightTO> charStuffs = getCharStuffs(charClothesAndStuffs);
    result.setStuffs(charStuffs);
	return result;
	}
	
	public GameEnterTO getCharBody() {
	GameEnterTO result = new GameEnterTO();
	UserDAO userDAO = new UserDAO(getSession());
    User user = userDAO.findById(getAdapter().getUserId());
	GameChar gameChar = user.getGameChar();
	result.setBody(StringUtil.encodeB(notNull(gameChar.getBody())));
	return result;
	}
	
	

    public void setLocale(String locale) {
        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(getAdapter().getUserId());
        user.setLocale(locale);
        userDAO.makePersistent(user);
    }

    public PetTO getPet(GameChar gameChar) {

        Pet pet = new PetDAO(getSession()).findByChar(gameChar);

        if (pet != null && pet.isEnabled()) {
            return new PetTO(pet);
        } else {
            return null;
        }
    }

    @SuppressWarnings("unchecked")
    public CharHomeTO getCharHome(Integer userId) throws IllegalAccessException, InvocationTargetException {
        CharHomeTO homeTO = new CharHomeTO();
        StuffItemDAO stuffItemDAO = new StuffItemDAO(getSession());
        User user = new UserDAO(getSession()).findById(userId.longValue());
        homeTO.setCitizen(user.isCitizen());
        homeTO.setRep(user.getHomeRep());
        GameChar gameCharIdent = user.getGameCharIdentifier();
        List<StuffItem> items = stuffItemDAO.findByTypes(gameCharIdent, new String[]{StuffTypes.HOUSE}, false);
        for (StuffItem item : items) {
            StuffTypeTO stuffTypeTO = new StuffTypeTO();
            BeanUtils.copyProperties(stuffTypeTO, item.getType());
            homeTO.getItems().add(stuffTypeTO);
        }
        List<StuffItem> furnitureItems = stuffItemDAO.findByTypes(gameCharIdent, new String[]{StuffTypes.FURNITURE},
                false);
        boolean citizen = user.getCitizenExpirationDate() != null && user.getCitizenExpirationDate().after(new Date());
        if (!citizen) {
            for (Iterator iterator = furnitureItems.iterator(); iterator.hasNext(); ) {
                StuffItem stuffItem = (StuffItem) iterator.next();
                if (stuffItem.isUsed() && stuffItem.getLevel() != null && stuffItem.getLevel() > 0) {
                    stuffItem.setUsed(false);
                    stuffItemDAO.makePersistent(stuffItem);
                }
            }
        }
        List<StuffItemLightTO> furnitureTos = ReflectUtil.convertBeansByConstructorStuffItemLightTO(furnitureItems);
        homeTO.setFurniture(furnitureTos);
        homeTO.setRobotExists(new RobotDAO(getSession()).robotExists(user));
        homeTO.setCrit(user.getHomeCrit());
        return homeTO;
    }

    @SuppressWarnings("unchecked")
    public Double getSessionTime(Integer userId, Date minDate, Date maxDate) {

        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(userId.longValue());

        Query query = getSession().getNamedQuery(QueriesNames.LOGIN_STATISTICS_SESSION_TIME);

        query.setParameter("user", user);
        query.setParameter("minDate", minDate);
        query.setParameter("maxDate", maxDate);

        // ArrayList<Object> list = (ArrayList<Object>) query.list();
        List list = query.list();

        return (list.size() == 1) ? (Long) list.get(0) : 0.00;
    }

    public void setUserInfo(Integer userId, Boolean enabled, Boolean chatEnabledByParent, Boolean isParent) {

        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(userId.longValue());
        user.setEnabled(enabled);
        user.setChatEnabled(chatEnabledByParent);
        user.setParent(isParent);
        userDAO.makePersistent(user);
    }

    public ArrayList<String> removeCharFriends(LinkedHashMap<Integer, Integer> removedFriends) throws HibernateException,
            SQLException {

        UserDAO userDAO = new UserDAO(getSession());

        for (Integer friendId : removedFriends.values()) {

            userDAO.removeFriendship(UserManager.getInstance().getCurrentUser().getUserId(), friendId.longValue());
        }

        return getCharFriends(null, false);
    }

	public void sendAchievement(Integer userId, String Type, String Message) {
		UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(userId.longValue());
		
		//new RemoteClient(getSession(), user).sendCommand("UpdateSpinCommand", 0);
		
        user.setAchievements(user.getAchievements() + Type);
        userDAO.makePersistent(user);
		
		//sendAchievementMessage(Message);
		//Achievement unlocked! Good work, you've been rewarded 500 bugs. Complete tougher quests for better prizes!
		new RemoteClient(getSession(), user).sendCommand("AchievementCommand", "Woah, Achievement unlocked: " + Message);
		userAdmin.addMoney(getSession(), 500, "Achievement unlocked!");
		new UserUtil().addCrowns(getSession(), userId.longValue(), 5);
    }
	
	public void addCheck(Integer userId, Integer Check, String Type) {
		UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(userId.longValue());
		ChallengesDAO challengesDAO = new ChallengesDAO(getSession());		
		Challenges challenges = challengesDAO.findByType(Type);
		if(challenges.getActive() != null) {
			if(!user.getChallenges().contains(Type)) {
				if(challenges.getActive() == 1) {
					user.setCheck1(user.getCheck1() + Check);
					userDAO.makePersistent(user);
					if(user.getCheck1() >= challenges.getHighestScore()) {
						challenges.setCharName(user.getLogin());
						challenges.setHighestScore(user.getCheck1());
						challengesDAO.makePersistent(challenges);
					}
				} else if(challenges.getActive() == 2) {
					user.setCheck2(user.getCheck2() + Check);
					userDAO.makePersistent(user);
					if(user.getCheck2() >= challenges.getHighestScore()) {
						challenges.setCharName(user.getLogin());
						challenges.setHighestScore(user.getCheck2());
						challengesDAO.makePersistent(challenges);
					}
				} else if(challenges.getActive() == 3) {
					user.setCheck3(user.getCheck3() + Check);
					userDAO.makePersistent(user);
					if(user.getCheck3() >= challenges.getHighestScore()) {
						challenges.setCharName(user.getLogin());
						challenges.setHighestScore(user.getCheck3());
						challengesDAO.makePersistent(challenges);
					}
				}
			}
		}
    }
	
	public void checkChallenge(Integer userId, Integer Check, String Type) {
		UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(userId.longValue());
		ChallengesDAO challengesDAO = new ChallengesDAO(getSession());
		//System.err.println("called: " + Type);
		Challenges challenges = challengesDAO.findByType(Type);
		if(challenges != null) {
			if(Check >= challenges.getAmountNeeded()) {
				user.setChallenges(user.getChallenges() + Type + ";");
				userDAO.makePersistent(user);
				userAdmin.addMoney(getSession(), 20000, "Completing a Challenge!");
				//addCrowns(20);
				new UserUtil().addCrowns(getSession(), userAdmin.getUserId(), 20);
			}
		}
    }
	
    public void addToBuddyList(Integer mainID, Integer otherID) throws HibernateException, SQLException {
        UserDAO userDAO = new UserDAO(getSession());
        userDAO.addToBuddyList(mainID, otherID);
    }

    public ArrayList<String> removeIgnoreChar(Integer ignoreId) {

        GameCharDAO charDAO = new GameCharDAO(getSession());
        GameChar friend = charDAO.findByUserId(ignoreId.longValue());
        GameChar gameChar = getGameChar();

        if (gameChar.getIgnoreList().contains(friend)) {
            gameChar.getIgnoreList().remove(friend);
            charDAO.makePersistent(gameChar);
        }
        return getIgnoreList();
    }

	public int getTier() {
        User user = getUser();
        return user.getTier();
    }
	
	public Boolean purchaseSeasonPass() {
		UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(getAdapter().getUserId());
		GameChar gameChar = user.getGameChar();
		
		if(gameChar.getEmeralds() >= 50) {
            //if(user.getPermissions().indexOf("season1Pass;") == -1) {
			if(user.getPermissions().indexOf("season2Pass;") == -1) {
				getAdapter().addEmeralds(getSession(), -50, "stuff season pass");
				user.setPermissions(user.getPermissions() + "season2Pass;");
                //user.setPermissions(user.getPermissions() + "season1Pass;");
				new RemoteClient(getSession(), user).sendCommand("DialogOKCommand", "Successfully bought the Season Pass!");
				getAdapter().executeCommand("UpdatePermCommand", user.getPermissions());
				new UserUtil().giveSeasonItems(getSession(), getAdapter().getUserId());
				return true;
			}
		} else {
			new RemoteClient(getSession(), user).sendCommand("DialogOKCommand", "You need more emeralds to do this!");
		}
		return false;
	}
	
	public int getCrowns() {
        User user = getUser();
        return user.getCrowns();
    }

	public int getCheck1() {
        User user = getUser();
        return user.getCheck1();
    }
	
	public int getCheck2() {
        User user = getUser();
        return user.getCheck2();
    }
	
	public int getCheck3() {
        User user = getUser();
        return user.getCheck3();
    }
	
    public Double getCharMoney() {
        UserManager.getInstance().getCurrentUser().checkLogin();
        GameChar gameChar = getGameChar();
        return gameChar.getMoney();
    }

    public Double getCharEmeralds() {
        UserManager.getInstance().getCurrentUser().checkLogin();
        GameChar gameChar = getGameChar();
        return gameChar.getEmeralds();
    }

    public Double getCharCandy() {
        UserManager.getInstance().getCurrentUser().checkLogin();
        GameChar gameChar = getGameChar();
        return gameChar.getCandy();
    }

    public String getCharGender() {
        UserManager.getInstance().getCurrentUser().checkLogin();
        GameChar gameChar = getGameChar();
        return gameChar.getGender();
    }

    public String getCharChatColor() {
        UserManager.getInstance().getCurrentUser().checkLogin();
        GameChar gameChar = getGameChar();
        return gameChar.getChatColor();
    }


    public ArrayList<String> getCharFriends() {
        User user = getUser();
        return getCharFriends(user, true);
    }

    public ArrayList<String> getCharFriends(User us, boolean setCity) {

        ArrayList<FriendTO> result = new ArrayList<FriendTO>();

        long start = System.currentTimeMillis();
        User user = us;
        if (user == null) {
            user = getUser();
        }
        List<User> userFriends = user.getFriends();

        for (User friendUser : userFriends) {
            if (friendUser == null) {
                logger.error("Invalid char in friends charId: " + user.getId());
                continue;
            }

            FriendTO friend = new FriendTO();
            friend.setUserId(friendUser.getId().intValue());
            friend.setLogin(friendUser.getLogin());
            result.add(friend);
        }
        //System.err.println("Select friends time: " + (System.currentTimeMillis() - start));

        if (setCity) {

            start = System.currentTimeMillis();
            List<Long> userIds = new ArrayList<Long>();
            for (User member : userFriends) {
                userIds.add(member.getId());
            }
            if (!userIds.isEmpty()) {

                List<UserServer> userServers = new UserServerDAO(getSession()).getUserServerByUserIds(userIds.toArray());
                for (FriendTO friend : result) {
                    for (Iterator<UserServer> iterator = userServers.iterator(); iterator.hasNext(); ) {
                        UserServer userServer = iterator.next();
                        if (userServer.getUserId().intValue() == friend.getUserId()) {
                            friend.setServer(ServersCache.getInstance().getServerName(userServer));
                            userServers.remove(userServer);
                            break;
                        }
                    }
                }
            }
        }

        ArrayList<String> res = new ArrayList<String>();
        for (int i = 0; i < result.size(); i++) {
            FriendTO friend = result.get(i);
            res.add(friend.toStringPresentation());
        }

        //System.err.println("Select friends servers time: " + (System.currentTimeMillis() - start));
        return res;
    }

    public ArrayList<String> getIgnoreList() {

        GameChar gameChar = getGameChar();
        ArrayList<String> result = new ArrayList<String>();

        for (GameChar friend : gameChar.getIgnoreList()) {
            result.add(friend.getLogin());
        }

        return result;
    }

    public ArrayList<String> setCharFriend(Integer friendId) {

        UserDAO userDAO = new UserDAO(getSession());
        User friend = new UserDAO(getSession()).findById(friendId.longValue());
        User user = getUser();
        ArrayList<String> result;

        synchronized (friendSynchronizer) {
            if (!user.getFriends().contains(friend)) {
                user.getFriends().add(friend);
                userDAO.makePersistent(user);
            }

            if (!friend.getFriends().contains(user)) {
                friend.getFriends().add(user);
                userDAO.makePersistent(friend);
            }

            result = getCharFriends(user, false);
            afterCall();
        }

        return result;
    }


    public ArrayList<String> setIgnoreChar(Integer ignorChardUserId) {

        GameCharDAO charDAO = new GameCharDAO(getSession());
        GameChar friend = charDAO.findByUserId(ignorChardUserId.longValue());
        GameChar gameChar = getGameChar();

        if (!gameChar.getIgnoreList().contains(friend)) {
            gameChar.getIgnoreList().add(friend);
            charDAO.makePersistent(gameChar);
        }
        return getIgnoreList();
    }

    @SuppressWarnings("unchecked")
    private List<StuffItemLightTO> getCharStuffs(List<StuffItem> items) {

        return ReflectUtil.convertBeansByConstructorStuffItemLightTO(items);
    }

    @SuppressWarnings("unchecked")
    public List<String> getCharStuffs() {
        List<String> result = new ArrayList<String>();
        List<StuffItemLightTO> items = ReflectUtil.convertBeansByConstructorStuffItemLightTO(getCharClothesAndStuffs(null,
                null, false, false));
        // UserAdapter userAdapter = UserManager.getInstance().getCurrentUser();
        // userAdapter.loadCharStuffs(items);
        for (Iterator iterator = items.iterator(); iterator.hasNext(); ) {
            StuffItemLightTO stuffItemLightTO = (StuffItemLightTO) iterator.next();
            result.add(stuffItemLightTO.toString());
        }
        return result;
    }

    private List<StuffItem> getCharClothesAndStuffs(User us, GameChar gc, boolean disableCitizens, boolean selectUsedOnly) {

        User user = us;
        if (user == null) {
            UserAdapter userAdapter = UserManager.getInstance().getCurrentUser();
            user = new UserDAO(getSession()).findById(userAdapter.getUserId());
        }

        GameChar gameChar = gc;
        if (gameChar == null) {
            gameChar = user.getGameCharIdentifier();
        }

        CharTOCache.getInstance().removeCharTO(user.getId());
        CharTOCache.getInstance().removeCharTO(user.getLogin());
        StuffItemDAO itemDAO = new StuffItemDAO(getSession());
        long now = System.currentTimeMillis();
        List<StuffItem> items = itemDAO.findByTypes(gameChar, new String[]{StuffTypes.CLOTHES, StuffTypes.STUFF,
                StuffTypes.COCKTAIL, StuffTypes.PET_ITEMS, StuffTypes.PLAYERCARD}, selectUsedOnly);
        //System.err.println("itemDAO.findByTypes time: " + (System.currentTimeMillis() - now));

        if (disableCitizens) {
            now = System.currentTimeMillis();
            for (StuffItem item : items) {
                if (item.isUsed() && item.getType().getPremium()) {
                    item.setUsed(false);
                    itemDAO.makePersistent(item);
                }
            }
            //System.err.println("disableCitizens clothes time: " + (System.currentTimeMillis() - now));
        }
        return items;
    }

    public CharTO getCharView(Integer userId) {
        CharTO result = CharTOCache.getInstance().getCharTO(userId.longValue());
        if (result != null) {
            return result;
        }

        User user = new UserDAO(getSession()).findById(userId.longValue(), false);

        if (user == null)
            return null;
        else
            return getUserInfo(user);
    }

    public CharTO getCharViewLogin(String charName) {
        CharTO result = CharTOCache.getInstance().getCharTO(charName);
        if (result != null) {
            return result;
        }

        User user = new UserDAO(getSession()).findByLogin(charName, false);

        if (user == null){
            return null;
        } else {
            return getUserInfo(user, false, true);
        }
    }

    public List<CharTO> getFamilyInfo() {

        Long userId = UserManager.getInstance().getCurrentUser().getUserId();
        UserDAO userDAO = new UserDAO(getSession());
        String email = userDAO.findById(userId).getEmail();
        List<User> users = userDAO.findByEmail(email, true);

        List<CharTO> items = new ArrayList<CharTO>();

        for (User user : users) {
            if (!user.getGuest())
                items.add(getUserInfo(user));
        }

        return items;
    }

    private static final Map<Long, String> STUFFTYPES_TYPES_CACHE = new HashMap<Long, String>();

    private CharTO getUserInfo(User user) {
        return getUserInfo(user, true, false);
    }

    private CharTO getUserInfo(User user, boolean checkCurrentUserCache, boolean setCurrentUserLogin) {
        GameChar gameChar = user.getGameChar();

        BanDAO banDAO = new BanDAO(getSession());
        Ban ban = banDAO.findByUser(user);
        if (ban == null) {
            ban = new Ban();
        }

        Server server = new UserServerDAO(getSession()).getServer(user);

        CharTO result = new CharTO();

        Long age = UserUtil.getAge(user);

        result.setUserId(user.getId().intValue());
        result.setTeam(user.getTeam());
        result.setId(user.getLogin());
        result.setBody(gameChar.getBody());
        result.setGender(gameChar.getGender());
        result.setChatColor(gameChar.getChatColor());
        result.setColor(gameChar.getColor());
        result.setChatEnabled(ban.isChatEnabled());
        result.setPictureChat(user.isPictureChat());
        result.setChatEnabledByParent(user.isChatEnabled());
        result.setChatBanLeftTime(BanUtil.getBanLeftTime(ban).intValue());
        result.setEnabled(user.isEnabled());
        result.setParent(user.isParent());
        result.setCitizen(user.getCitizenExpirationDate() != null && user.getCitizenExpirationDate().after(new Date()));
        result.setGuest(user.getGuest() || !user.isActive());
        result.setAgent(user.isAgent());
        result.setMerchant(user.isMerchant());
        result.setResetPass(user.isResetPass());
        result.setDefaultFrame(user.isDefaultFrame());
        result.setStatus(user.getStatus());
        result.setLocation(user.getLocation());
        result.setJournalist(user.isJournalist());
        result.setEliteJournalist(user.isEliteJournalist());
        result.setArtist(user.isArtist());
        result.setSupport(user.isSupport());
        result.setScout(user.isScout());
        result.setStaff(user.isStaff());
        result.setDes(user.isDes());
        result.setDev(user.isDev());
        result.setExperience(user.getExperience());
        result.setUIColour(user.getUIColour());
		result.setCheck1(user.getCheck1());
		result.setCheck2(user.getCheck2());
		result.setCheck3(user.getCheck3());
        result.setCharLevel(user.getCharLevel());
        result.setChatLog(user.getChatLog());
        result.setPurchasedBubbles(user.getPurchasedBubbles());
        result.setPurchasedCards(user.getPurchasedCards());
        result.setPermissions(user.getPermissions());
        result.setAchievements(user.getAchievements());
        result.setChallenges(user.getChallenges());
        result.setPurchasedBodies(user.getPurchasedBodies());
        result.setOutfits(user.getOutfits());
        result.setBankMoney(user.getBankMoney());
        result.setaccessToken(user.getaccessToken());
        result.setTwitterName(user.getTwitterName());
        result.setaccessTokenSecret(user.getaccessTokenSecret());
        result.setBlog(user.isBlog());
        result.setLastOnlineDay(getLastOnlineDay(user.getId().intValue()));
        result.setModerator(user.isModerator());
        result.setForumer(user.isForumer());
        result.setPublicLocation(user.getPublicLocation());
        result.setBlogURL(user.getBlogURL());
        result.setOnline(server != null);
        result.setLocale(user.getLocale());
        result.setAge(age.intValue());
        result.setAcceptRequests(user.getAcceptRequests());
        result.setAcceptNight(user.getAcceptNight());
        result.setHasRobot(new RobotDAO(getSession()).robotExists(user));
        if (user.getRobotTeam() != null) {
            result.setTeamName(user.getRobotTeam().getUserLogin());
            result.setTeamColor(user.getRobotTeam().getColor());
        }

        if (gameChar.getPlayerCard() != null)
            result.setPlayerCard(new StuffItemLightTO(gameChar.getPlayerCard()));

        if (server != null)
            result.setServer(server.getName());

        ArrayList<StuffItemLightTO> clothes = new ArrayList<StuffItemLightTO>();

        for (StuffItem item : gameChar.getStuffItems()) {
            if (item.isUsed()) {
                String type = STUFFTYPES_TYPES_CACHE.get(item.getType_id());
                if (type == null) {
                    type = item.getType().getType();
                    STUFFTYPES_TYPES_CACHE.put(item.getType_id(), type);
                }

                if (StuffTypes.CLOTHES.equals(type)) {
                    clothes.add(new StuffItemLightTO(item));
                }
            }
        }

        result.setClothes(clothes);
        result.setLogin(user.getLogin());
        if (!checkCurrentUserCache)
            return result;

        UserAdapter currentUser = UserManager.getInstance().getCurrentUser();
        if (setCurrentUserLogin) {
            currentUser.setLogin(user.getLogin());
            currentUser.setUserId(user.getId());
        }
        Long currentServerId = null;
        if (currentUser != null && currentUser.getServer() != null) {
            currentServerId = currentUser.getServer().getId();
        }
        String currentUserLogin = currentUser.getLogin();
        boolean cacheUser = true;
        if (!user.getLogin().equals(currentUserLogin)) {
            if (server == null)
                cacheUser = false;
            else if (!server.getId().equals(currentServerId))
                cacheUser = false;
        }
        if (cacheUser) {
            CharTOCache.getInstance().putCharTO(result);
        }
        return result;
    }

    public void saveCharStuffs(LinkedHashMap<Integer, ObjectMap<String, Object>> clothes) {
        for (StuffItem item : getCharClothesAndStuffs(null, null, false, false)) {

            for (ObjectMap<String, Object> clothe : clothes.values()) {
                Long id = Long.valueOf((Integer) clothe.get("id"));
                if (id.equals(item.getId())) {
                    item.setUsed((Boolean) clothe.get("used"));
                    item.setX((Integer) clothe.get("x"));
                    item.setY((Integer) clothe.get("y"));
                    item.setColor((Integer) clothe.get("color"));
                    item.setColorSec((Integer) clothe.get("colorSec"));

                    break;
                }
            }
        }
    }

    private User getUser() {
        UserAdapter userAdapter = UserManager.getInstance().getCurrentUser();
        return new UserDAO(getSession()).findById(userAdapter.getUserId());
    }

    private GameChar getGameChar() {
        UserAdapter userAdapter = UserManager.getInstance().getCurrentUser();
        return new UserDAO(getSession()).findById(userAdapter.getUserId()).getGameChar();
    }

    public void setGender(String gender) {
        GameChar gameChar = getGameChar();
        gameChar.setGender(gender);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

    public void setMoney(Integer money) {
        GameChar gameChar = getGameChar();
        gameChar.setMoney(gameChar.getMoney() + money - gameChar.getMoney());
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

    public void setEmeralds(Integer emeralds) {
        GameChar gameChar = getGameChar();
        gameChar.setEmeralds(gameChar.getEmeralds() + emeralds - gameChar.getEmeralds());
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

    public void setCandy(Integer candy) {
        GameChar gameChar = getGameChar();
        gameChar.setCandy(gameChar.getCandy() + candy);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

    public void removeCandy(Integer candy) {
        GameChar gameChar = getGameChar();
        gameChar.setCandy(gameChar.getCandy() - candy);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }


    /*public Boolean setChatColor(String chatColor) {
        GameChar gameChar = getGameChar();
        gameChar.setChatColor(chatColor);
        new GameCharDAO(getSession()).makePersistent(gameChar);
        return true;
    }*/

    public void setEmail(Integer userId, String email) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().setEmail(getSession(), userId, email);
    }

    public void setBlogLink(String blogLink) {
        GameChar gameChar = getGameChar();
        gameChar.setBlogLink(blogLink);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

    public void saveCharBodyNormal(String body, Integer color){
        GameChar gameChar = getGameChar();
        gameChar.setBody(body);
        gameChar.setColor(color);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }

	public void saveOutfits(String Outfits) {
		System.out.println("Saved Outfit: " + Outfits);
		UserDAO dao = new UserDAO(getSession());
		Long id = UserManager.getInstance().getCurrentUser().getUserId();
		User user = dao.findById(id);
        user.setOutfits(Outfits);
        dao.makePersistent(user);
		//new UserUtil().setOutfits(getSession(), userAdmin.getUserId(), Outfits);
	}
	
    public void saveCharBody(String body, Integer color) {
	   UserDAO userDAO = new UserDAO(getSession());
       User user = userDAO.findByLogin(userAdmin.getLogin());
	   String userBodies = user.getPurchasedBodies();
	   String[] bodies = userBodies.split(",");
	    if(Arrays.asList(bodies).contains(body)){
			GameChar gameChar = getGameChar();
			gameChar.setBody(body);
			gameChar.setColor(color);
			new GameCharDAO(getSession()).makePersistent(gameChar);
		}else{
			ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack a body", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
				new ClientErrorDAO(getSession()).makePersistent(adminLog);
		}
	}

    /*public void saveBodyPanel(String body, Integer color) {
        GameChar gameChar = getGameChar();
        gameChar.setBody(body);
        gameChar.setColor(color);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }*/
	
		
	public Boolean saveBodyPanel(String body, Integer color, String charName) {
	System.out.println("BODY IS: " + body);
	  GameChar gameChar = getGameChar();
	  UserDAO userDAO = new UserDAO(getSession());
      User user = userDAO.findByLogin(charName);
	  Boolean isModerator = user.isModerator();
	    String userBodies = user.getPurchasedBodies();
        String[] bodies = userBodies.split(",");	
		if(isModerator == true){
		      gameChar.setBody(body);
              gameChar.setColor(color);
              new GameCharDAO(getSession()).makePersistent(gameChar);
			  return true;
		}else{
		if(Arrays.asList(bodies).contains(body)){
              gameChar.setBody(body);
              gameChar.setColor(color);
              new GameCharDAO(getSession()).makePersistent(gameChar);
			  return true;
	      }else{
		gameChar.setBody("default");
			  gameChar.setColor(color);
			  new GameCharDAO(getSession()).makePersistent(gameChar);
	          ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack a body", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
              new ClientErrorDAO(getSession()).makePersistent(adminLog);
			  saveUserBan(Ints.checkedCast(userAdmin.getUserId()), true, "Hacking a Body in Body Panel.");
			  return false;
		}
	  }
	}
	
	public Boolean saveBodyPanelToDefault (Integer color, String charName) {
		GameChar gameChar = getGameChar();
		gameChar.setBody("default");
		gameChar.setColor(color);
		new GameCharDAO(getSession()).makePersistent(gameChar);
		return true;
	}
	
	public Boolean setChatColor(String chatColor, String charName) {
	//System.out.println("CHAT IS: " + chatColor);
	  GameChar gameChar = getGameChar();
	  UserDAO userDAO = new UserDAO(getSession());
      User user = userDAO.findByLogin(charName);
	  Boolean isModerator = user.isModerator();
	    String userBubbles = user.getPurchasedBubbles();
	    String[] bubbles = userBubbles.split(",");
		if(isModerator == true){
		      gameChar.setChatColor(chatColor);
              new GameCharDAO(getSession()).makePersistent(gameChar);
              return true;
		}else{
			if(Arrays.asList(bubbles).contains(chatColor)){
				gameChar.setChatColor(chatColor);
				new GameCharDAO(getSession()).makePersistent(gameChar);
				return true;
			}else{
				gameChar.setChatColor("default");
				new GameCharDAO(getSession()).makePersistent(gameChar);
				ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack a chat color", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
				new ClientErrorDAO(getSession()).makePersistent(adminLog);
				saveUserBan(Ints.checkedCast(userAdmin.getUserId()), true, "Hacking a Chat Color in Body Panel.");
				return false;
			}
		}
	}
	
	public void setChatColorToDefault(String charId){
		GameChar gameChar = getGameChar();
		gameChar.setChatColor("default");
		new GameCharDAO(getSession()).makePersistent(gameChar);
	}
	
	public void saveUserBan(Integer userId, Boolean banned, String reason) {
        UserDAO dao = new UserDAO(getSession());
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        //ClientError adminLog = new ClientError("Banned user " + julia.getLogin() + " because " + reason, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        User user = dao.findById(userId.longValue());
        String messages = getLastChatMessages(user);
        if (banned == true){
		new UserUtil().kickOut(user, banned, getSession());
        new UserUtil().saveUserBan(getSession(), user, banned, reason, messages);
	    }
    }
	
	public String getLastChatMessages(User user) {
        return new RemoteClient(getSession(), user).getLastChatMessages();
    }
	
	public Boolean savePlayerCardColorDefault() {
	 UserDAO dao = new UserDAO(getSession());
      Long id = UserManager.getInstance().getCurrentUser().getUserId();
      User user = dao.findById(id);
	  user.setTeam("undefined");
      dao.makePersistent(user);
	  return true;
	}

	public Boolean savePlayerCardColor(String pcColor) {
	//	System.out.println("Playercard color: " + pcColor);
		UserDAO dao = new UserDAO(getSession());
		Long id = UserManager.getInstance().getCurrentUser().getUserId();
		User user = dao.findById(id);
		Boolean isModerator = user.isModerator();
		String cards = user.getPurchasedCards();
		String[] cardz = cards.split(",");
		if(isModerator == true){
			user.setTeam(pcColor);
			dao.makePersistent(user);
			return true;
		} else {
			if(Arrays.asList(cardz).contains(pcColor)){
				user.setTeam(pcColor);
				dao.makePersistent(user);
				return true;
			}else{
				user.setTeam("undefined");
				dao.makePersistent(user);
				ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack a player card color", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
				new ClientErrorDAO(getSession()).makePersistent(adminLog);
				saveUserBan(Ints.checkedCast(userAdmin.getUserId()), true, "Hacking a Playercard Color in Body Panel.");
				return false;
			}
		}

	}

    public void savePlayerCard(Integer stuffId) {
        StuffItem stuff = null;
        if (stuffId >= 0) {
            StuffItemDAO stuffDAO = new StuffItemDAO(getSession());
            stuff = stuffDAO.findById(new Long(stuffId));
        }
        GameChar gameChar = getGameChar();
        gameChar.setPlayerCard(stuff);
        new GameCharDAO(getSession()).makePersistent(gameChar);
    }


    @SuppressWarnings("unchecked")
    private List<ObjectMap<String, Object>> getOfflineCommands(GameChar gameChar) {
        long now = System.currentTimeMillis();
        MessageDAO messageDAO = new MessageDAO(getSession());

        List<Message> messageList = messageDAO.getMessages(gameChar);
        List<ObjectMap<String, Object>> messages = new ArrayList<ObjectMap<String, Object>>();

        for (Message msg : messageList) {
            ObjectMap<String, Object> command = (ObjectMap<String, Object>) msg.getCommand();
            if (!command.get("className").equals(GIFT_CLASS_NAME)) {
                command.put("id", msg.getId());
                messages.add(command);
            } else {
                new MessageDAO(getSession()).makeTransient(msg);
            }
        }
        //System.err.println("getOfflineCommands time: " + (System.currentTimeMillis() - now));

        return messages;
    }

    public void saveDance(String value, Integer index) {
        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(getAdapter().getUserId());
        UserDanceDAO userDanceDAO = new UserDanceDAO(getSession());
        List<UserDance> list = user.getDances();
        if (list.size() == 0) {
            for (int i = 0; i < DANCES_COUNT; i++) {
                UserDance dance = new UserDance("");
                list.add(dance);
                userDanceDAO.makePersistent(dance);
            }

        }
        UserDance dance = list.get(index);
        dance.setDance(value);
        userDanceDAO.makePersistent(dance);
    }

    public Integer makePresent(Integer userId, Integer stuffId) {
        //  if (1 == 1)
        //    return stuffId;
        StuffItemDAO itemDAO = new StuffItemDAO(getSession());
        StuffItem item = itemDAO.findById(stuffId.longValue(), false);
        if(!(item.getGameChar().getId().equals(userAdmin.getChar(getSession()).getId()))){
             ClientError adminLog = new ClientError("Tried to hack GIFT; item does NOT BELONG", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            userAdmin.goodBye("hack", false);
            return null;
        }

        item.resetOwner();
        GameChar friend = new UserDAO(getSession()).findById(userId.longValue()).getGameCharIdentifier();
        item.setGameChar(friend);
        itemDAO.makePersistent(item);

        return stuffId;
    }

    public KeysTO gK/* getKey */() {
        return new KeysTO(getAdapter().newSecurityKey(), MessageService.KEY);
    }
    // public GameEnterTO enterGame(Object charName) {
//	  return null;
    // }

    public GameEnterTO enterGame(String charName, String pass) {
        long nowTot = System.currentTimeMillis();

        long start = System.currentTimeMillis();

        UserAdapter userAdapter = getAdapter();
        userAdapter.enterGame();

        long finish = System.currentTimeMillis();
        String checkPoint1 = "" + (finish - start);

        start = System.currentTimeMillis();
        GameEnterTO result = new GameEnterTO();
        result.setSecurityKey(userAdapter.newSecurityKey());
        populateStaticData(result);
        if (!userAdapter.getPersistent())
            return result;
        result.setIsGuest(false);
        finish = System.currentTimeMillis();
        String checkPoint2 = "" + (finish - start);

        start = System.currentTimeMillis();
        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findByLogin(charName);
        if (user == null) {
            // fixing stupid case sensitive problem :(
            user = userDAO.findByLogin(charName.toLowerCase());
        }
        if (!user.getPassword().equals(pass)) {
            userAdapter.goodBye("hack", false);
        }
        finish = System.currentTimeMillis();
        String checkPoint3 = "" + (finish - start);

        start = System.currentTimeMillis();
        GameCharDAO charDAO = new GameCharDAO(getSession());
        GameChar gameChar = user.getGameChar();
        finish = System.currentTimeMillis();
        String checkPoint4 = "" + (finish - start);

        start = System.currentTimeMillis();
        BanDAO banDAO = new BanDAO(getSession());
        Ban ban = banDAO.findByUser(user);
        finish = System.currentTimeMillis();
        String checkPoint5 = "" + (finish - start);

        start = System.currentTimeMillis();
        if (ban == null) {
            ban = new Ban();
        }
        List<StuffItem> charClothesAndStuffs = getCharClothesAndStuffs(user, gameChar, !user.isCitizen(), false);

        List<StuffItem> usedCharClothesAndStuffs = new ArrayList<StuffItem>();
        // getting only used stuffs to optimize traffic
        for (Iterator<StuffItem> iterator = charClothesAndStuffs.iterator(); iterator.hasNext(); ) {
            StuffItem stuffItem = iterator.next();
            if (stuffItem.isUsed()) {
                usedCharClothesAndStuffs.add(stuffItem);
            }
        }

        finish = System.currentTimeMillis();
        String checkPoint6 = "" + (finish - start);

        start = System.currentTimeMillis();
        MembershipInfo mi = user.getMembershipInfo();
        finish = System.currentTimeMillis();
        String checkPoint7 = "" + (finish - start);
        start = System.currentTimeMillis();
        if (mi == null) {
            mi = new MembershipInfo();
        }

        boolean saveMemberShipInfo = false;

        result.setFinishedNotification(false);
        result.setFinishingNotification(false);

        Date citizenshipExpiration = user.getCitizenExpirationDate();
        if (citizenshipExpiration != null) {
            if (!mi.getFinishedNotificationShowed() && citizenshipExpiration.before(new Date())) {
                result.setFinishedNotification(true);
                mi.setFinishedNotificationShowed(true);
                saveMemberShipInfo = true;
            } else if (!mi.getFinishedNotificationShowed() && !mi.getFinishingNotificationShowed()
                    && DateUtil.daysDiff(citizenshipExpiration, new Date()) < 7) {
                mi.setFinishingNotificationShowed(true);
                result.setFinishingNotification(true);
                saveMemberShipInfo = true;
            }
        }
        finish = System.currentTimeMillis();
        String checkPoint8 = "" + (finish - start);

        start = System.currentTimeMillis();
        if (saveMemberShipInfo) {
            mi = (new MembershipInfoDAO(getSession())).makePersistent(mi);
            user.setMembershipInfo(mi);
            userDAO.makePersistent(user);
        }
        finish = System.currentTimeMillis();
        String checkPoint9 = "" + (finish - start);

        start = System.currentTimeMillis();
        result.setServerInSafeMode(KavalokApplication.getInstance().isSafeModeEnabled());
        result.setDrawingMode(KavalokApplication.getInstance().isDrawingEnabled());
        result.setNonCitizenChatDisabled(false);
        result.setChatEnabled(ban.isChatEnabled());
        result.setPictureChat(user.isPictureChat());
        result.setChatBanLeftTime(BanUtil.getBanLeftTime(ban));
        finish = System.currentTimeMillis();
        String checkPoint91 = "" + (finish - start);

        start = System.currentTimeMillis();
        result.setFirstLogin(gameChar.getFirstLogin());
        result.setBody(StringUtil.encodeB(notNull(gameChar.getBody())));
        result.setGender(gameChar.getGender());
        result.setChatColor(StringUtil.encodeB(notNull(gameChar.getChatColor())));
        result.setBlogLink(gameChar.getBlogLink());
        result.setColor(gameChar.getColor());
        result.setMoney(gameChar.getMoney());
        result.setEmeralds(gameChar.getEmeralds());
        result.setCandy(gameChar.getCandy());
        List<StuffItemLightTO> charStuffs = getCharStuffs(usedCharClothesAndStuffs);
        result.setStuffs(charStuffs);
        finish = System.currentTimeMillis();
        String checkPoint92 = "" + (finish - start);

        start = System.currentTimeMillis();
        result.setFriends(getCharFriends(user, false));
        finish = System.currentTimeMillis();
        String checkPoint10 = "" + (finish - start);

        start = System.currentTimeMillis();
        result.setIgnoreList(getIgnoreList());
        result.setCommands(getOfflineCommands(gameChar));
        result.setPet(getPet(gameChar));
        result.setQuests(getQuests());
        populateFromUser(result, user, gameChar);
        finish = System.currentTimeMillis();
        String checkPoint101 = "" + (finish - start);

        start = System.currentTimeMillis();
        result.setRobot(RobotUtil.getCharRobot(getSession(), user.getId().intValue()));
        finish = System.currentTimeMillis();
        String checkPoint11 = "" + (finish - start);

        start = System.currentTimeMillis();
        result.setRobotTeam(getRobotTeam(user));
        result.setCrew(getCrew(user));
        if (user.getRobotTeam() != null) {
            result.setTeamColor(user.getRobotTeam().getColor());
        }
        if (user.getCrew() != null) {
            result.setCrewColor(user.getCrew().getColor());
        }
        finish = System.currentTimeMillis();
        String checkPoint12 = "" + (finish - start);

        start = System.currentTimeMillis();
        StuffItem playerCard = gameChar.getPlayerCard();
        if (playerCard != null) {
            if (!user.isCitizen() && Boolean.TRUE.equals(playerCard.getType().getPremium())) {
                gameChar.setPlayerCard(null);
            } else {
                result.setPlayerCard(new StuffItemLightTO(playerCard));
            }
        }
        finish = System.currentTimeMillis();
        String checkPoint13 = "" + (finish - start);

        start = System.currentTimeMillis();
        // new AdminClient(getSession()).logUserEnter(user.getLogin(),
        // gameChar.getFirstLogin());
        gameChar.setFirstLogin(false);
        charDAO.makePersistent(gameChar);
        finish = System.currentTimeMillis();
        String checkPoint14 = "" + (finish - start);

        if (user.isCitizen()) {
            // TODO enabling timer to disable citizen features;
        }
        notifyFriends();
        nowTot = (System.currentTimeMillis() - nowTot);

        System.err.println(charName + " enters the game");

        /*System.err.println("enterGame char: " + charName + ", time: " + (nowTot) + "\n" + "Check points: "
                + " \ncheckPoint1: " + checkPoint1 + " \ncheckPoint2: " + checkPoint2 + " \ncheckPoint3: " + checkPoint3
                + " \ncheckPoint4: " + checkPoint4 + " \ncheckPoint5: " + checkPoint5 + " \ncheckPoint6: " + checkPoint6
                + " \ncheckPoint7: " + checkPoint7 + " \ncheckPoint8: " + checkPoint8 + " \ncheckPoint9: " + checkPoint9
                + " \ncheckPoint91: " + checkPoint91 + " \ncheckPoint92: " + checkPoint92 + " \ncheckPoint10: " + checkPoint10
                + " \ncheckPoint101: " + checkPoint101 + " \ncheckPoint11: " + checkPoint11 + " \ncheckPoint12: "
                + checkPoint12 + " \ncheckPoint13: " + checkPoint13 + " \ncheckPoint14: " + checkPoint14);*/

        userAdapter.loadCharStuffs(getCharStuffs(charClothesAndStuffs));
        result.setAge(UserUtil.getAge(user));

        return result;
    }

    public void notifyFriends(){

        List<BestFriends> bestFriends = new BestFriendsDAO(getSession()).findWhoToSend(getAdapter().getUserId());
        for (BestFriends bf : bestFriends) {
            if(bf.isEnabled()){
             Long bfId = bf.getFriendId();
             UserDAO userDAO = new UserDAO(getSession());
             User user = userDAO.findById(bfId);
             new RemoteClient(getSession(), user).sendCommand("FriendOnlineCommand", getAdapter().getLogin());
         }
        }
    }

    public String addBestFriend(Integer userId){
        BestFriendsDAO bestFriendsDAO = new BestFriendsDAO(getSession());
        BestFriends alreadyFriends = bestFriendsDAO.findPreciseFriend(userId.longValue(), getAdapter().getUserId());

        if(alreadyFriends == null){    
            BestFriends bestFriends = new BestFriends(userId.longValue(), getAdapter().getUserId(), true);
            bestFriendsDAO.makePersistent(bestFriends);
            return "success";
        } else {
            alreadyFriends.setEnabled(true);
            bestFriendsDAO.makePersistent(alreadyFriends);
            return "success";
        }

    }
    

    public String removeBestFriend(Integer userId){
        BestFriendsDAO bestFriendsDAO = new BestFriendsDAO(getSession());
        BestFriends bestFriends = bestFriendsDAO.findPreciseFriend(userId.longValue(), getAdapter().getUserId());
        bestFriends.setEnabled(false);
        bestFriendsDAO.makePersistent(bestFriends);
        return "success";
    }

    public Boolean isBestFriend(Integer userId){
        BestFriendsDAO bestFriendsDAO = new BestFriendsDAO(getSession());
        BestFriends alreadyFriends = bestFriendsDAO.findPreciseFriend(userId.longValue(), getAdapter().getUserId());

        if(alreadyFriends == null)
            return false;
        else if(!alreadyFriends.isEnabled())
            return false;
        else 
            return true;
    }

    private String notNull(String str) {
        if (str == null) {
            return "";
        } else {
            return str;
        }
    }

    private void populateStaticData(GameEnterTO result) {
        result.setChatSecurityKey(MessageService.KEY);
        result.setServerTime(new Date());
        result.setColor((int) (Math.random() * 0xFFFFFF));
        result.setIsGuest(true);
        result.setFirstLogin(true);
        result.setHelpEnabled(false);
        result.setShowTips(false);
    }

    private void populateFromUser(GameEnterTO result, User user, GameChar gameChar) {
        result.setHelpEnabled(user.isHelpEnabled());
        result.setNotActivated(!user.isActive());
        result.setChatEnabledByParent(getBool(user.isChatEnabled()));
        result.setPictureChat(user.isPictureChat());
        // result.setIsGuest(user.getGuest());
        result.setEmail(StringUtil.encodeB(notNull(user.getEmail())));
        result.setWhatExperience(user.getExperience());
        result.setWhatUIColour(user.getUIColour());
        result.setWhatCheck1(user.getCheck1());
        result.setWhatCheck2(user.getCheck2());
        result.setWhatCheck3(user.getCheck3());
        result.setWhatAccessToken(user.getaccessToken());
        result.setWhatTwitterName(user.getTwitterName());
        result.setWhatAccessTokenSecret(user.getaccessTokenSecret());
        result.setWhatLevel(user.getCharLevel());
        result.setWhatChatLog(user.getChatLog());
        result.setWhatPurchasedBubbles(StringUtil.encodeB(notNull(user.getPurchasedBubbles())));
        result.setWhatPurchasedCards(StringUtil.encodeB(notNull(user.getPurchasedCards())));
        result.setWhatPermissions(StringUtil.encodeB(notNull(user.getPermissions())));
        result.setWhatAchievements(user.getAchievements());
        result.setWhatChallenges(user.getChallenges());
        result.setWhatPurchasedBodies(StringUtil.encodeB(notNull(user.getPurchasedBodies())));
        result.setWhatOutfits(user.getOutfits());
        result.setWhatBankMoney(user.getBankMoney());
        result.setWhatLocation(user.getLocation());
        result.setIsAgent(user.isAgent());
        result.setIsMerchant(user.isMerchant());
        result.setIsResetPass(user.isResetPass());
        result.setIsDefaultFrame(user.isDefaultFrame());
        result.setIsArtist(user.isArtist());
        result.setIsJournalist(user.isJournalist());
        result.setIsEliteJournalist(user.isEliteJournalist());
        result.setIsSupport(user.isSupport());
        result.setIsScout(user.isScout());
        result.setIsDev(user.isDev());
        result.setIsDes(user.isDes());
        result.setStatus(user.getStatus());
        result.setIsStaff(user.isStaff());
        result.setIsCitizen(user.isCitizen());
        result.setIsBlog(user.isBlog());
        result.setLastOnlineDay(getLastOnlineDay(user.getId().intValue()));
        result.setCitizenExpirationDate(user.getCitizenExpirationDate());
        result.setCitizenTryCount(user.getCitizenTryCount());
        result.setIsModerator(getBool(user.isModerator()));
        result.setIsForumer(user.isForumer());
        result.setWhatPublicLocation(user.getPublicLocation());
        result.setIsParent(user.isParent());
        result.setCreated(user.getCreated());
        result.setDrawEnabled(getBool(user.getDrawEnabled()));
        result.setBlogURL(user.getBlogURL());
        result.setAcceptRequests(user.getAcceptRequests());
        result.setAcceptNight(user.getAcceptNight());
        result.setMusicVolume(user.getMusicVolume());
        result.setSoundVolume(user.getSoundVolume());
        result.setShowTips(user.getShowTips());
        result.setShowCharNames(gameChar.getShowCharNames());
        result.setDances(user.getDancesData());
        result.setSuperUser(user.getSuperUser());
        result.setUserId(user.getId());
        getAdapter().newPrivKey();
        result.setPrivKey(getAdapter().getPrivKey());
    }

    public List<FriendTO> getRobotTeam() {
        User user = new UserDAO(getSession()).findById(getAdapter().getUserId());
        return getRobotTeam(user);
    }

    public List<FriendTO> getCrew() {
        User user = new UserDAO(getSession()).findById(getAdapter().getUserId());
        return getCrew(user);
    }

    private String getBool(Boolean bool) {
        if (bool)
            return userAdmin.getLogin();
        else
            return "F";
    }

    private List<FriendTO> getRobotTeam(User user) {
        List<FriendTO> result = new ArrayList<FriendTO>();
        if (user.getRobotTeam() == null) {
            return result;
        }
        List<User> members = new UserDAO(getSession()).findByRobotTeam(user.getRobotTeam());
        List<Long> userIds = new ArrayList<Long>();
        for (User member : members) {
            userIds.add(member.getId());
        }
        if (!userIds.isEmpty()) {
            List<UserServer> userServers = new UserServerDAO(getSession()).getUserServerByUserIds(userIds.toArray());
            for (User member : members) {
                FriendTO friend = new FriendTO();
                friend.setUserId(member.getId().intValue());
                friend.setLogin(member.getLogin());
                for (Iterator<UserServer> iterator = userServers.iterator(); iterator.hasNext(); ) {
                    UserServer userServer = iterator.next();
                    if (userServer.getUserId().equals(member.getId())) {
                        friend.setServer(ServersCache.getInstance().getServerName(userServer));
                        userServers.remove(userServer);
                        break;
                    }
                }
                if (member.getId().equals(user.getRobotTeam().getUser_id())) {
                    result.add(0, friend);
                } else {
                    result.add(friend);
                }
            }
        }
        return result;
    }

    private List<FriendTO> getCrew(User user) {
        List<FriendTO> result = new ArrayList<FriendTO>();
        if (user.getCrew() == null) {
            return result;
        }
        List<User> members = new UserDAO(getSession()).findByCrew(user.getCrew());
        List<Long> userIds = new ArrayList<Long>();
        for (User member : members) {
            userIds.add(member.getId());
        }
        if (!userIds.isEmpty()) {
            List<UserServer> userServers = new UserServerDAO(getSession()).getUserServerByUserIds(userIds.toArray());
            for (User member : members) {
                FriendTO friend = new FriendTO();
                friend.setUserId(member.getId().intValue());
                friend.setLogin(member.getLogin());
                for (Iterator<UserServer> iterator = userServers.iterator(); iterator.hasNext(); ) {
                    UserServer userServer = iterator.next();
                    if (userServer.getUserId().equals(member.getId())) {
                        friend.setServer(ServersCache.getInstance().getServerName(userServer));
                        userServers.remove(userServer);
                        break;
                    }
                }
                if (member.getId().equals(user.getCrew().getUser_id())) {
                    result.add(0, friend);
                } else {
                    result.add(friend);
                }
            }
        }
        return result;
    }

    private List<Object> getQuests() {
        List<Object> result = new QuestDAO(getSession()).findEnabled(KavalokApplication.getInstance().getServer());
        return result;
    }

}
