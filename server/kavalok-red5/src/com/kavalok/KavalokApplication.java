package com.kavalok;

import java.io.FileReader;
import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Timer;
import java.net.*;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import net.sf.cglib.core.ReflectUtils;

import org.hibernate.Session;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.so.ISharedObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.cache.ShopCacheCleaner;
import com.kavalok.dao.ConfigDAO;
import com.kavalok.dao.ServerDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.dao.UserServerDAO;
import com.kavalok.db.Server;
import com.kavalok.db.User;
import com.kavalok.db.UserServer;
import com.kavalok.dto.CharTOCache;
import com.kavalok.messages.UsersCache;
import com.kavalok.messages.WordsCache;
import com.kavalok.statistics.ServerUsageStatistics;
import com.kavalok.transactions.DefaultTransactionStrategy;
import com.kavalok.transactions.ITransactionStrategy;
import com.kavalok.transactions.TransactionUtil;
import com.kavalok.user.BadClientsCleaner;
import com.kavalok.user.OnlineUsersCleaner;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;
import com.kavalok.utils.HibernateUtil;
import com.kavalok.utils.ReflectUtil;
import com.kavalok.utils.SOManager;

public class KavalokApplication extends MultiThreadedApplicationAdapter {

    public static final String CONTEXT_FORMAT = "%1s/%2$s";

    public static Logger logger = LoggerFactory.getLogger(KavalokApplication.class);

    private boolean started = false;

    private boolean safeModeEnabled = false;

	private String mutedRooms = "";

    private boolean drawingEnabled = false;

    private boolean registrationEnabled = false;

    private int spamMessagesCount = 100;

    private int stuffGroupNum = 100;

    private boolean guestEnabled = false;

    private int serverLimit = 250;

    private int gameVersion = 0;

    private String savedData = "off_loc3";

    private Timer serverUsageTimer;

    private Timer serverUsersCleanerTimer;

    private Timer clientsCleanerTimer;

    private Timer shopCacheCleanerTimer;

    public static KavalokApplication getInstance() {
        return instance;
    }

    private static KavalokApplication instance;
    private String serverPath;
    private String serverName;
    private Server server;
    private java.util.Properties properties;
    private ApplicationConfig applicationConfig;

    public KavalokApplication() {
        instance = this;
    }

    public boolean hasSharedObject(String name) {
        return hasSharedObject(scope, name);
    }

    public ISharedObject createSharedObject(String name) {
        if (!hasSharedObject(name))
            createSharedObject(scope, name, false);
        return getSharedObject(name);
    }

    public ISharedObject getSharedObject(String name) {
        return getSharedObject(scope, name);
    }

    public String getCurrentServerPath() {
        return serverPath;
    }

    @Override
    public boolean appStart(IScope scope) {

		//boolean fail = true;
		/*
		boolean fail = false;
		String check = "";
		try{
    		check = getUrlSource("https://yasminevans.net/chobots/check.php");
    		if(check.contains("OK")){
				fail = false;
    		}
    	} catch(IOException e){
			logger.error(e.toString());
			logger.error("Please ensure that you are connected to the internet and all root certs are up to date.");
    		System.exit(1);
    	}

		if(fail){
			logger.error(check);
			System.exit(1);
			return false;
		}
*/
        String path = getClassesPath() + "/kavalok.properties";
        properties = new java.util.Properties();
        try {
            properties.load(new FileReader(path));
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        String applicationPropsPath = getClassesPath() + "/application.properties";
        try {
            Properties applicationProperties = new Properties();
            applicationProperties.load(new FileReader(applicationPropsPath));
            applicationConfig = new ApplicationConfig(applicationProperties);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        addListener(getScope(), new SOManager());
        HibernateUtil.getSessionFactory();
        WordsCache.getInstance();// load words
        String name = scope.getName();
		serverPath = String.format(CONTEXT_FORMAT, "game.kavalok.net", name);
        //serverPath = "game.kavalok.net/kavalok";//String.format(CONTEXT_FORMAT, getHostIP(), name);
        logger.warn("app start -> new " + serverPath);
        refreshServerState(true);

        serverUsageTimer = new Timer("ServerUsageStatistics timer", true);
        serverUsageTimer.schedule(new ServerUsageStatistics(), 0, ServerUsageStatistics.DELAY);
        // new ServerUsageStatistics().start();

        serverUsersCleanerTimer = new Timer("OnlineUsersCleaner timer", true);
        serverUsersCleanerTimer.schedule(new OnlineUsersCleaner(), 0, OnlineUsersCleaner.DELAY);

        clientsCleanerTimer = new Timer("BadClientsCleaner timer", true);
        clientsCleanerTimer.schedule(new BadClientsCleaner(), 0, BadClientsCleaner.DELAY);

        shopCacheCleanerTimer = new Timer("ShopCacheCleaner timer", true);
        shopCacheCleanerTimer.schedule(new ShopCacheCleaner(), 0, ShopCacheCleaner.DELAY);

        refreshConfig();

        /*Test test = new Test();
        test.doSayHi();

        System.out.println("Instantiating a groovy class -> " + test);
        System.out.println("Look what groovy said -> " + test.lolGetName());
        System.out.println("    KavalokApplication setup complete.");*/
        return true;
    }

    public String getClassesPath() {
        String path = ReflectUtil.getRootPath(KavalokApplication.class);
        if (path.contains("lib/kavalok.jar")) // deployed as jar
        {
            path = path.substring(0, path.indexOf("lib/kavalok.jar")) + "classes";
            path = path.substring("file:/".length(), path.length());
        }
        return path;
    }

    @Override
    public void appStop(IScope scope) {
        super.appStop(scope);
        // SOManager.getInstance().dispose();
        refreshServerState(false);
        serverUsageTimer.cancel();
    }

    private String getHostIP() {
        return properties.getProperty("host.ip");
    }

    public ApplicationConfig getApplicationConfig() {
        return applicationConfig;
    }

    public void refreshConfig() {
        DefaultTransactionStrategy strategy = new DefaultTransactionStrategy();
        try {
            strategy.beforeCall();

            ConfigDAO configDAO = new ConfigDAO(strategy.getSession());
            setGuestEnabled(configDAO.getGuestEnabled());
            setRegistrationEnabled(configDAO.getRegistrationEnabled());
            setSafeModeEnabled(configDAO.getSafeModeEnabled());
			setMutedRooms(configDAO.getMutedRooms());
            setDrawingEnabled((configDAO.getDrawingWallDisabled() ? false : true));

            setServerLimit(configDAO.getServerLimit());
            setGameVersion(configDAO.getGameVersion());
            setSavedData(configDAO.getSavedData());
            setSpamMessagesCount(configDAO.getSpamMessagesCount());
            setStuffGroupNum(configDAO.getStuffGroupNum());

            System.out.println("** -> Refreshing application config... <- ** > ");

            strategy.afterCall();
        } catch (Exception e) {
            strategy.afterError(e);
            logger.error(e.getMessage(), e);
        }
    }

    private void refreshServerState(boolean available) {
        DefaultTransactionStrategy strategy = new DefaultTransactionStrategy();
        try {
            strategy.beforeCall();
            ServerDAO serverDAO = new ServerDAO(strategy.getSession());
            Server server = serverDAO.findByUrl(getCurrentServerPath());
            setServerName(server.getName());

            UserServerDAO usDAO = new UserServerDAO(strategy.getSession());
            List<UserServer> list = usDAO.getAllUserServer(server);
            for (Iterator<UserServer> iterator = list.iterator(); iterator.hasNext(); ) {
                UserServer userServer = (UserServer) iterator.next();
                usDAO.makeTransient(userServer);
            }
            server.setRunning(available);
            // this.server = new RemoteServer(server.getPort());

            serverDAO.makePersistent(server);
            setServer(server);
            strategy.afterCall();
        } catch (Exception e) {
            strategy.afterError(e);
            logger.error(e.getMessage(), e);
        }
    }

    public Object call(String className, String method, List<Object> args) throws ClassNotFoundException,
            InstantiationException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Class<?> type = Class.forName(className);
        ITransactionStrategy service = (ITransactionStrategy) ReflectUtils.newInstance(type);
        return TransactionUtil.callTransaction(service, method, args);
    }

    @Override
    public void appDisconnect(IConnection conn) {
        // logger.debug("app disconnect");
        DefaultTransactionStrategy strategy = new DefaultTransactionStrategy();
        try {
            strategy.beforeCall();
            disconnectUser(strategy.getSession());
            strategy.afterCall();
        } catch (Exception e) {
            strategy.afterError(e);
            e.printStackTrace();
            logger.error(e.getMessage(), e);
        } finally {
            super.appDisconnect(conn);
        }
    }

    public boolean appConnect(IConnection conn, Object[] params) {
		return true;
	}

	//public boolean appConnect(IConnection conn, Object[] params) {
	//	String token = (String)params[0];
	//	System.out.println(token);
	//	if(!(conn.getHost().equals("game.kavalok.net"))){
	//		return false;
	//	}

	//	if(checkToken(token)){
	//		logger.warn("Connection allow token -> (" + token + ")");
	//		return true;
	//	} else {
	//		logger.warn("Connection DENY token -> (" + token + ")");
			//Close unauthorised connection
	//		conn.close();
	//		return false;
	//	}
	//}

	/**
	 * Not my code, just coppied, it works.
	 */
   public static String getUrlSource(String url) throws IOException {
        URLConnection urlConnection = new URL(url).openConnection();
		urlConnection.addRequestProperty("User-Agent", "Mozilla");
        BufferedReader in = new BufferedReader(new InputStreamReader(
                urlConnection.getInputStream(), "UTF-8"));
        String inputLine;
        StringBuilder a = new StringBuilder();
        while ((inputLine = in.readLine()) != null)
            return inputLine;
        in.close();

        return a.toString();
    }

    public String state_new = "";

    //public boolean checkToken(String token){
	//	try{
    //		state_new = getUrlSource("https://kavalok.net/token?CHECK_REQUEST=" + token);
    //		if(state_new.toString().trim().contains("Success")){
    //			return true;
    //		} else {
    //			return true;
    //		}
    //	} catch(IOException e){
    //		e.printStackTrace();
    //	}
    //	return false;
    //}

    public void disconnectUser(Session session) {
        UserAdapter userAdapter = UserManager.getInstance().getCurrentUser();
        if (userAdapter.getUserId() != null) {
            logger.info("User {} disconnect", userAdapter.getLogin());
            UserDAO userDAO = new UserDAO(session);
            User user = userDAO.findById(userAdapter.getUserId());
            if (user == null) {
                userAdapter.dispose();
                return;
            }
            boolean updateUser = userAdapter.updateStatistics(session, user);
            userAdapter.dispose();
            UserServerDAO usDAO = new UserServerDAO(session);
            List<UserServer> list = usDAO.getAllUserServer(userAdapter.getUserId());
            for (Iterator<UserServer> iterator = list.iterator(); iterator.hasNext(); ) {
                UserServer userServer = (UserServer) iterator.next();
                usDAO.makeTransient(userServer);
            }
            if (updateUser)
                userDAO.makePersistent(user);

            CharTOCache.getInstance().removeCharTO(user.getId());
            CharTOCache.getInstance().removeCharTO(user.getLogin());
            UsersCache.getInstance().removeUser(user.getId());
            userAdapter.dispose();
        }

    }

    public boolean isSafeModeEnabled() {
        return safeModeEnabled;
    }

    public void setSafeModeEnabled(boolean safeModeEnabled) {
        this.safeModeEnabled = safeModeEnabled;
    }

	public String listMutedRooms() {
	   return mutedRooms;
	}

	public void setMutedRooms(String mutedReums) {
	    this.mutedRooms = mutedReums;
	}

    public boolean isDrawingEnabled() {
    	return drawingEnabled;
    }

    public void setDrawingEnabled(boolean drawingEnabled) {
        this.drawingEnabled = drawingEnabled;
    }

    public String getServerName() {
        return serverName;
    }

    public void setServerName(String serverName) {
        this.serverName = serverName;
    }

    public Server getServer() {
        return server;
    }

    public void setServer(Server server) {
        this.server = server;
    }

    public boolean isRegistrationEnabled() {
        return registrationEnabled;
    }

    public void setRegistrationEnabled(boolean registrationEnabled) {
        this.registrationEnabled = registrationEnabled;
    }

    public int getStuffGroupNum() {
        return stuffGroupNum;
    }

    public void setStuffGroupNum(int stuffGroupNum) {
        this.stuffGroupNum = stuffGroupNum;
    }

    public boolean isGuestEnabled() {
        return guestEnabled;
    }

    public void setGuestEnabled(boolean guestEnabled) {
        this.guestEnabled = guestEnabled;
    }

    public int getServerLimit() {
        return serverLimit;
    }

    public void setServerLimit(int serverLimit) {
        this.serverLimit = serverLimit;
    }

    public int getGameVersion() {
        return gameVersion;
    }

    public void setGameVersion(int gameVersion) {
        this.gameVersion = gameVersion;
    }

    public String getSavedData() {
        return savedData;
    }

    public void setSavedData(String savedData) {
        this.savedData = savedData;
    }


    public int getSpamMessagesCount() {
        return spamMessagesCount;
    }

    public void setSpamMessagesCount(int spamMessagesCount) {
        this.spamMessagesCount = spamMessagesCount;
    }

}
