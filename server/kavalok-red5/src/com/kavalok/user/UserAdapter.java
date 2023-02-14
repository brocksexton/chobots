package com.kavalok.user;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;
import java.util.concurrent.Executors;

import org.hibernate.Session;
import com.kavalok.utils.StringUtil;
import org.red5.server.api.IBasicScope;
import org.red5.server.api.IClient;
import org.red5.server.api.Red5;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.so.ISharedObject;

import com.kavalok.KavalokApplication;
import com.kavalok.dao.GameCharDAO;
import com.kavalok.dao.UserExtraInfoDAO;
import com.kavalok.dao.statistics.LoginStatisticsDAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.Server;
import com.kavalok.db.ClientError;
import com.kavalok.dao.ClientErrorDAO;
import com.kavalok.db.StuffItem;
import com.kavalok.db.StuffType;
import com.kavalok.db.ClientError;
import com.kavalok.dao.ClientErrorDAO;
import com.kavalok.db.User;
import com.kavalok.xmlrpc.AdminClient;
import com.kavalok.permissions.AccessAdmin;
import com.kavalok.db.UserExtraInfo;
import com.kavalok.db.statistics.LoginStatistics;
import com.kavalok.db.statistics.MoneyStatistics;
import com.kavalok.dto.stuff.StuffItemLightTO;
import com.kavalok.services.common.SimpleEncryptor;

public class UserAdapter {

    private static final int MESSAGES_TO_LOG_COUNT = 100;

    private static final int MONEY_STATS_CACHE_MAX_SIZE = 20;

    private static String LOCATION_CHAT_MESSAGE_HANDLER = "lc";

    private static String DISABLE_CHAT_HANDLER = "onDisableChat";

    private static String LOAD_STUFF_HANDLER = "loadStuff";

    private static String LOAD_STUFF_END_HANDLER = "loadStuffEnd";

    private static String LOCATION_MOVE_HANDLER = "lm";

    private static String DISABLE_CHAT_ADMIN_HANDLER = "onDisableChatAdmin";

    private static String SKIP_CHAT_HANDLER = "onSkipChat";

    private static String COMMAND_HANDLER = "onCommand";

    private static String COMMAND_INSTANCE_HANDLER = "onCommandInstance";

    private IClient client;

    private IServiceCapableConnection connection;

    private Long userId;

    private String login;

    private String creationStackTrace;

    private Server server;

    private Boolean persistent = true;

    private Date loginDate;

    private String panelName;

    private Date lastTick;

    private Byte[] securityKey;


    private String privKey;

    private Stack<String> messagesStack = new Stack<String>();

    private List<MoneyStatistics> MONEY_STATS_CACHE = new ArrayList<MoneyStatistics>();

    @SuppressWarnings("unchecked")
    private Class accessType;

    private Boolean isAdmin = false;

    public String loggedInPassword = "doHDOh";
    public String realPassword = "";


    public UserAdapter() {
        super();
        messagesStack.setSize(MESSAGES_TO_LOG_COUNT);
        client = new Red5().getClient();
        connection = (IServiceCapableConnection) Red5.getConnectionLocal();
        StackTraceElement[] trace = Thread.currentThread().getStackTrace();
        for (int i = 0; i < trace.length; i++) {
            String el = trace[i].toString();
            this.creationStackTrace = this.creationStackTrace + el + "\n<br>";
        }
    }

    public Boolean checkLogin() {
        if (!loggedInPassword.equals(realPassword)) {
            this.goodBye("Incorrect login", false);
            return false;
        } else {
            return true;
        }
    }

    public void setAdmin(Boolean val) {
        isAdmin = val;
    }

    public Boolean getAdminStatus() {
        return isAdmin;
    }


    public IServiceCapableConnection getConnection() {
        return connection;
    }

    public Byte[] getSecurityKey() {
        return securityKey;
    }


    public Byte[] newSecurityKey() {
        securityKey = SimpleEncryptor.generateKey();
        return securityKey;
    }

     public void newPrivKey() {
        String key = StringUtil.generateRandomString(12);

        privKey = key;
        executeCommand("GHzwPr35ZdfMm", StringUtil.encodeB(key));
        // executeCommand("HTTP1", StringUtil.toBase64(key2) + "9v3p" + StringUtil.toBase64(key) + "2zDp" + key2);
    }

    public String newPrivKeyAlone() {
        String key = StringUtil.generateRandomString(12);

        privKey = StringUtil.encodeB(key);
        return privKey;
        // executeCommand("HTTP1", StringUtil.toBase64(key2) + "9v3p" + StringUtil.toBase64(key) + "2zDp" + key2);
    }

    public Boolean processKey(String key, Session session, String file) {
        if (!key.equals(privKey)) {
			System.out.println("actual privKey is: " + privKey);
            ClientError adminLog = new ClientError("[HACKER ALERT]" + login + ": tried to hack " + file, getConnection().getRemoteAddress(), getUserId(), true);
            new ClientErrorDAO(session).makePersistent(adminLog);
            this.goodBye("The system could not validate this action. It is possible that you are trying to hack.", false);

            return false;
        }
        newPrivKey();
        return true;
    }

    public String getPrivKey() {
        return privKey;
    }

    public GameChar getChar(Session session) {
        GameChar gameChar = new GameCharDAO(session).findByUserId(userId);
        return gameChar;
    }

    public List<String> getSharedObjects() {
        ArrayList<String> result = new ArrayList<String>();
        Iterator<IBasicScope> iterator = getConnection().getBasicScopes();
        while (iterator.hasNext()) {
            IBasicScope scope = iterator.next();
            if (scope instanceof ISharedObject) {
                result.add(((ISharedObject) scope).getName());
            }
        }
        return result;
    }

    public void enterGame() {
        loginDate = new Date();
    }

    public IClient getClient() {
        return client;
    }

    public void setClient(IClient client) {
        this.client = client;
    }

    public List<StuffType> getStuff(Session session) {
        List<StuffType> result = new ArrayList<StuffType>();
        GameChar gameChar = new GameCharDAO(session).findByUserId(userId);
        for (StuffItem item : gameChar.getStuffItems()) {
            result.add(item.getType());
        }
        return result;
    }

    public Double getMoney(Session session) {
        GameChar gameChar = new GameCharDAO(session).findByUserId(userId);
        return gameChar.getMoney();
    }

	 public Double getEmeralds(Session session) {
        GameChar gameChar = new GameCharDAO(session).findByUserId(userId);
        return gameChar.getEmeralds();
    }
	
    public List<String> getClothes(Session session) {
        GameCharDAO charDAO = new GameCharDAO(session);
        GameChar gameChar = charDAO.findByUserId(userId);
        return charDAO.getUsedClothes(gameChar);
    }

  /*
   * public void updateAll(Session session) { sharedObject.beginUpdate();
   * sharedObject.setAttribute(ATTRIBUTE_STUFF, getStuff(session));
   * sharedObject.setAttribute(ATTRIBUTE_MONEY, getMoney(session));
   * sharedObject.setAttribute(ATTRIBUTE_CLOTHES, getClothes(session));
   * sharedObject.endUpdate(); }
   */

    public void addMoney(Session session, long money, String reason) {
        addMoney(session, new User(userId), money, reason);
    }

    public void addMoney(Session session, User user, long money, String reason) {
        GameCharDAO gameCharDAO = new GameCharDAO(session);
        GameChar gameChar = gameCharDAO.findByUserId(user.getId());
        gameChar.setMoney(money + gameChar.getMoney());
        if (money > 0) {
            gameChar.setTotalMoneyEarned(gameChar.getTotalMoneyEarned() + money);
            insertMoneyStatistics(session, money, reason, user);
        }
        gameCharDAO.makePersistent(gameChar);
        executeCommand("UpdateMoneyCommand", gameChar.getMoney());
    }
	
	public void addEmeralds(Session session, long emeralds, String reason) {
        addEmeralds(session, new User(userId), emeralds, reason);
    }

    public void addEmeralds(Session session, User user, long emeralds, String reason) {
        GameCharDAO gameCharDAO = new GameCharDAO(session);
        GameChar gameChar = gameCharDAO.findByUserId(user.getId());
        gameChar.setEmeralds(emeralds + gameChar.getEmeralds());
        gameCharDAO.makePersistent(gameChar);
        executeCommand("UpdateEmeraldsCommand", gameChar.getEmeralds());
    }

    private void insertMoneyStatistics(Session session, long money, String reason, User user) {
        if (MONEY_STATS_CACHE.size() > MONEY_STATS_CACHE_MAX_SIZE) {
            updateMoneyStatistics(session);
        }
        MoneyStatistics moneyStatistics = new MoneyStatistics(user, money, new Date(), reason);
        MONEY_STATS_CACHE.add(moneyStatistics);
    }

    public void disableChatAdmin(String reason, Boolean enabledByMod, Boolean enabledByParent) {
        connection.invoke(DISABLE_CHAT_ADMIN_HANDLER, new Object[]{reason, enabledByMod, enabledByParent});
    }

    public void disableChat(String reason, Long interval, Integer minutes) {
        connection.invoke(DISABLE_CHAT_HANDLER, new Object[]{reason, interval, minutes});
    }

    public void sendLocationChat(Integer senderId, String senderLogin, Object message) {
        connection.invoke(LOCATION_CHAT_MESSAGE_HANDLER, new Object[]{senderLogin, senderLogin, message});
    }

    public void sendLocationMove(Integer senderId, String senderLogin, Integer x, Integer y, Boolean petBusy) {
        connection.invoke(LOCATION_MOVE_HANDLER, new Object[]{senderLogin, senderLogin, x, y, petBusy,
                System.currentTimeMillis()});
    }

    public void skipChat(String reason, String message) {
        connection.invoke(SKIP_CHAT_HANDLER, new Object[]{reason, message});
    }

    public void executeCommand(String className, Object parameter) {
        connection.invoke(COMMAND_HANDLER, new Object[]{className, parameter});
    }

    public void executeCommand(Object command) {
        connection.invoke(COMMAND_INSTANCE_HANDLER, new Object[]{command});
    }

    public void setPanelName(String realName) {
        this.panelName = realName;
    }

    public String getPanelName() {
        return panelName;
    }

    public boolean updateStatistics(Session session, User user) {
        boolean result = false; // if user needs to be updated
        if (getPersistent() && getUserId() != null && loginDate != null) {
            LoginStatistics loginStatistics = new LoginStatistics(user, loginDate, new Date(), getConnection().getRemoteAddress(), getLogin());
            UserExtraInfo uei = user.getUserExtraInfo();
            if (uei == null) {
                uei = new UserExtraInfo();
                result = true; // there was no UserExtraInfo, so wee need to update
            }
            uei.setLastLoginDate(loginDate);
            uei.setLastLogoutDate(loginStatistics.getLogoutDate());
            new UserExtraInfoDAO(session).makePersistent(uei);
            user.setUserExtraInfo(uei);
            new LoginStatisticsDAO(session).makePersistent(loginStatistics);
        }
        updateMoneyStatistics(session);
        return result;
    }

    private static SimpleDateFormat SQL_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private void updateMoneyStatistics(Session session) {
        if (MONEY_STATS_CACHE.isEmpty())
            return;
        StringBuffer query = new StringBuffer("insert into MoneyStatistics (date, reason, user_id, money) values ");

        for (Iterator<MoneyStatistics> iterator = MONEY_STATS_CACHE.iterator(); iterator.hasNext(); ) {
            MoneyStatistics moneyStat = (MoneyStatistics) iterator.next();
            query.append("(");
            query.append("'").append(SQL_DATE_FORMAT.format(moneyStat.getDate())).append("',");
            query.append("'").append(moneyStat.getReason()).append("',");
            query.append(moneyStat.getUser().getId()).append(",");
            query.append(moneyStat.getMoney());
            query.append(")");
            if (iterator.hasNext())
                query.append(",");
        }
        MONEY_STATS_CACHE.clear();
        session.createSQLQuery(query.toString()).executeUpdate();
    }

    public void goodBye(String reason, boolean banned) {
        executeCommand("KickOutCommand", banned);
        dispose();
    }


    public void logCharOff(String reason) {
        executeCommand("LogOffCharCommand");
        dispose();
    }

    public void dispose() {
        client.disconnect();
        client.removeAttribute(UserManager.ADAPTER);
    }

    @SuppressWarnings("unchecked")
    public Class getAccessType() {
        return accessType;
    }

    @SuppressWarnings("unchecked")
    public void setAccessType(Class accessType) {
        this.accessType = accessType;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public boolean saveChatMessage(String chatMessage) {
        int count = 0;
        for (Iterator<String> iterator = messagesStack.iterator(); iterator.hasNext(); ) {
            String mess = iterator.next();
            if (mess != null && mess.trim().equals(chatMessage.trim()) && mess.trim().length() > 10) {
                count++;
            }
        }
        if (count >= KavalokApplication.getInstance().getSpamMessagesCount()) {
            return false;
        }
        messagesStack.push(chatMessage);
        return true;
    }

    private List<String> SHORT_MESSAGES = new ArrayList<String>();

    public List<String> addToShortList(String message) {
        List<String> result = null;
        String messageTrimmed = message.trim();
        if (messageTrimmed.length() > 0 && messageTrimmed.length() <= 2) {
            SHORT_MESSAGES.add(messageTrimmed);
        } else {
            if (SHORT_MESSAGES.size() > 1) {
                StringBuffer res = new StringBuffer();
                for (Iterator<String> iterator = SHORT_MESSAGES.iterator(); iterator.hasNext(); ) {
                    String mess = iterator.next();
                    if (mess != null) {
                        res.append(mess).append("\n");
                    }
                }
                result = new ArrayList<String>(SHORT_MESSAGES);
            }
            SHORT_MESSAGES.clear();
        }
        return result;
    }

    public String getLastChatMessages() {
        StringBuffer result = new StringBuffer();
        for (Iterator<String> iterator = messagesStack.iterator(); iterator.hasNext(); ) {
            String mess = iterator.next();
            if (mess != null) {
                result.append(mess).append("\n");
            }
        }
        return result.toString();
    }

    public Boolean getPersistent() {
        return persistent;
    }

    public void setPersistent(Boolean persistent) {
        this.persistent = persistent;
    }

    public Server getServer() {
        return server;
    }

    public void setServer(Server server) {
        this.server = server;
    }

    public Date getLastTick() {
        return lastTick;
    }

    public void setLastTick(Date lastTick) {
        this.lastTick = lastTick;
    }

    public void loadCharStuffs(final List<StuffItemLightTO> stuffs) {
        Runnable worker = new Runnable() {
            public void run() {
                try {
                    Thread.sleep(10000); // let user process previous stuff
                } catch (InterruptedException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }
                int totalCount = stuffs.size();
                List<String> portion = new ArrayList<String>();
                for (Iterator<StuffItemLightTO> iterator = stuffs.iterator(); iterator.hasNext(); ) {
                    StuffItemLightTO stuffItemLightTO = iterator.next();
                    if (!Boolean.TRUE.equals(stuffItemLightTO.getUsed()))
                        portion.add(stuffItemLightTO.toStringPresentation());

                    if (portion.size() == 75 || !iterator.hasNext()) {
                        //System.out.println("Sending clothes portion to: " + getLogin());
                        connection.invoke(LOAD_STUFF_HANDLER, new Object[]{portion});
                        portion.clear();
                        try {
                            Thread.sleep(1000);// let user process previous bunch of messages
                        } catch (InterruptedException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                    }
                }
                connection.invoke(LOAD_STUFF_END_HANDLER, new Object[]{totalCount});// something
                // like
                // checksum
            }
        };
        Executors.newCachedThreadPool().execute(worker);
    }

    public String getCreationStackTrace() {
        return creationStackTrace;
    }

    public void setCreationStackTrace(String creationStackTrace) {
        this.creationStackTrace = creationStackTrace;
    }

    public boolean isModerator() {
        return this.isModerator();
    }

    public boolean isAllowed() {
        return this.isModerator();
    }

    public boolean isBoughtBody() {
        return this.isBoughtBody();
    }

}
