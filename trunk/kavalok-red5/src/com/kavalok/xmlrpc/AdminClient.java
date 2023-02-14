package com.kavalok.xmlrpc;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.util.Map;

import org.hibernate.Session;

import com.kavalok.KavalokApplication;
import com.kavalok.dao.ServerDAO;
import com.kavalok.db.Server;
import com.kavalok.db.AdminMessage;


public class AdminClient extends ClientBase {

    private Session session;

    private static String adminIP = null;

    private static String adminCPath = null;

    public AdminClient(Session session) {
        super();
        this.session = session;
        if (adminIP == null) {
            ServerDAO serverDAO = new ServerDAO(this.session);
            Server server = serverDAO.findRunning().get(0);
            adminIP = server.getIp();
            adminCPath = server.getContextPath();
        }
        createXmlRpc(adminIP, adminCPath);
    }

    public void logMessage(String message) {
        invokeInNewThread("RemoteServer.logMessage", new Object[]{message});
    }

    public void logUserReport(String login, Integer userId, String message, Integer id) {
        invokeInNewThread("RemoteServer.logUserReport", new Object[]{login, userId, message, id});
    }

    public void logModAction(String login, String action, String date) {
        invokeInNewThread("RemoteServer.logModAction", new Object[]{login, action, date});
    }

    public void logUserMessage(String login, Integer userId, String message) {
        invokeInNewThread("RemoteServer.logUserMessage", new Object[]{login, userId, message});
    }

    public void logAdminMessage(String login, Integer userId, String message) {
        invokeInNewThread("RemoteServer.logAdminMessage", new Object[]{login, userId,
                KavalokApplication.getInstance().getServerName(), message});
    }

    public void logAdminMessage(String login, String message) {
        invoke("RemoteServer.logAdminMessage", new Object[]{login, KavalokApplication.getInstance().getServerName(), message});
    }

    public void logChatMessage(String login, String message, String sharedObjId) {
        invoke("RemoteServer.logChatMessage", new Object[]{login, message, sharedObjId});
    }

    public void logBadWord(String login, Integer userId, String word, String message, String type) {
        invokeInNewThread("RemoteServer.logBadWord", new Object[]{login, userId,
                KavalokApplication.getInstance().getServerName(), word, message, type});
    }

    private static List<Map<String, Object>> badWordsCache = new ArrayList<Map<String, Object>>();

    public void logBadWord(Map<String, Object> badWord) {
        badWordsCache.add(badWord);
        if (badWordsCache.size() >= 5) {
            invokeInNewThread("RemoteServer.logBadWord", new Object[]{KavalokApplication.getInstance().getServerName(),
                    badWordsCache.toArray()});
            badWordsCache.clear();
        }
    }

    // public void logUserEnter(String login, Boolean firstLogin) {
    // // logger.info("send command " + command.toString());
    // invoke("RemoteServer.logUserEnter", new Object[] { login,
    // getServerName(login), firstLogin });
    // }

}
