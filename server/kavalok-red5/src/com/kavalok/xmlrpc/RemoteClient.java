package com.kavalok.xmlrpc;

import org.hibernate.Session;
import org.red5.io.utils.ObjectMap;

import com.kavalok.dao.UserDAO;
import com.kavalok.dao.UserServerDAO;
import com.kavalok.db.Server;
import com.kavalok.db.User;
import com.kavalok.utils.HibernateUtil;

public class RemoteClient extends ClientBase {

    private String charName;

    public RemoteClient(Session session, User user, Server server) {
        super();
        this.charName = user.getLogin();
        Server currentServer = server;
        createXmlRpc(currentServer);
    }

    public RemoteClient(Session session, Long userId, Server server) {
        super();
        User user = new UserDAO(session).findById(userId);
        this.charName = user.getLogin();
        Server currentServer = server;
        createXmlRpc(currentServer);
    }

    public RemoteClient(Session session, User user) {
        super();
        this.charName = user.getLogin();
        Server currentServer = new UserServerDAO(session).getServer(user);
        createXmlRpc(currentServer);
    }

    public RemoteClient(Session session, Long userId) {
        super();
        User user = new UserDAO(session).findById(userId);
        this.charName = user.getLogin();
        Server currentServer = new UserServerDAO(session).getServer(user);
        createXmlRpc(currentServer);
    }


    public RemoteClient(Session session, String charName) {
        super();
        this.charName = charName;
        User user = new UserDAO(session).findByLogin(charName);
        Server currentServer = new UserServerDAO(session).getServer(user);
        createXmlRpc(currentServer);
    }

    public RemoteClient(Server server) {
        createXmlRpc(server);
    }

    public Object[] getGraphity(String wallId) {
        Object result = invoke("RemoteServer.getGraphity", new Object[]{wallId});
        return (Object[]) result;
    }

    public void clearGraphity(String wallId) {
        invokeInNewThread("RemoteServer.clearGraphity", new Object[]{wallId});
    }

    public Integer getNumConnectedChars(String sharedObjectId) {
        return (Integer) invoke("RemoteServer.getNumConnectedChars", new Object[]{sharedObjectId});
    }

    public void sendCommand(String commandName, Object parameter) {
        if (charName == null)
            invokeInNewThread("RemoteServer.sendCommand", new Object[]{commandName, parameter});
        else
            invokeInNewThread("RemoteServer.sendCommand", new Object[]{charName, commandName, parameter});
    }

    public void renewLocation(String id) {
        invokeInNewThread("RemoteServer.renewLocation", new Object[]{id});
    }

    public void sendState(String remoteId, String clientId, String method, String stateName, Object state) {
        invokeInNewThread("RemoteServer.sendState", new Object[]{remoteId, clientId, method, stateName,
                HibernateUtil.serialize(state)});
    }

    public String getSharedObjects() {
        Object result = invoke("RemoteServer.getUserLocations", new Object[]{charName});
        return (String) result;
    }

    public String getLastChatMessages() {
        Object result = invoke("RemoteServer.getUserLastChatMessages", new Object[]{charName});
        return (String) result;
    }

    public void sendCommandToAll(String commandName, Object parameter) {
        invokeInNewThread("RemoteServer.sendCommandToAll", new Object[]{commandName, parameter});
    }

    public void sendCommandToAll(ObjectMap<String, Object> command, String[] locales) {
        invokeInNewThread("RemoteServer.sendCommandToAll", new Object[]{HibernateUtil.serialize(command),
                HibernateUtil.serialize(locales)});
    }

    public void sendLocationCommand(String remoteId, ObjectMap<String, Object> command) {
        invokeInNewThread("RemoteServer.sendLocationCommand", new Object[]{remoteId, HibernateUtil.serialize(command)});
    }

    public void sendCommand(ObjectMap<String, Object> command) {
        // logger.info("send command " + command.toString());
        invoke("RemoteServer.sendCommand", new Object[]{charName, HibernateUtil.serialize(command)});
    }

    public void reboot() {
        invokeInNewThread("RemoteServer.ribut", new Object[]{});
    }

    public void moveWWW() {
        invokeInNewThread("RemoteServer.moveWWW", new Object[]{});
    }

    public void refreshServerConfig() {
        invokeInNewThread("RemoteServer.refreshServerConfig", new Object[]{});
    }

    public void refreshStuffTypeCache() {
        invokeInNewThread("RemoteServer.refreshStuffTypeCache", new Object[]{});
    }

    public void disableUserChat(Boolean enabledByMod, Boolean enabledByParent) {
        invokeInNewThread("RemoteServer.disableUserChat", new Object[]{charName, enabledByMod, enabledByParent});
    }

    public void kickOutUserNewThread(boolean banned) {
        long now = System.currentTimeMillis();
        invokeInNewThread("RemoteServer.KKKKuser", new Object[]{charName, banned});
        long diff = System.currentTimeMillis() - now;
        System.err.println("KICKOUT_CLIENT_CALL time user (RemoteClient.java line 136 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + charName);
        System.err.println("KICKOUT_CLIENT_CALL time ms (RemoteClient.java line 136 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + diff);
        if (diff > maxKickOutTime) {
            maxKickOutTime = diff;
            System.err.println("Max_KICKOUT_CLIENT_CALL time user (RemoteClient.java line 136 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + charName);
            System.err.println("Max_KICKOUT_CLIENT_CALL time ms (RemoteClient.java line 136 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + maxKickOutTime);
        }
    }

    private static long maxKickOutTime = 0;

    //public void kickOutUser(boolean banned) {
    public void KKKKuser(boolean banned) {
        long now = System.currentTimeMillis();
        invoke("RemoteServer.KKKKuser", new Object[]{charName, banned});
        long diff = System.currentTimeMillis() - now;
        System.err.println("KICKOUT_CLIENT_CALL time user (RemoteClient.java line 152 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + charName);
        System.err.println("KICKOUT_CLIENT_CALL time ms (RemoteClient.java line 152 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + diff);
        if (diff > maxKickOutTime) {
            maxKickOutTime = diff;
            System.err.println("Max_KICKOUT_CLIENT_CALL time user (RemoteClient.java line 152 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + charName);
            System.err.println("Max_KICKOUT_CLIENT_CALL time ms (RemoteClient.java line 152 RemoteServer.KKKKuser) - brock added this because it annoyed him at some point: " + maxKickOutTime);
        }
    }

    //public void logCharOff() {
    public void LKKKKuser() {
        long now = System.currentTimeMillis();
        invoke("RemoteServer.LKKKKuser", new Object[]{charName});
        long diff = System.currentTimeMillis() - now;
        System.err.println("KICKOUT_CLIENT_CALL time user (RemoteClient.java line 166 RemoteServer.LKKKKuser) - brock added this because it annoyed him at some point: " + charName);
        System.err.println("KICKOUT_CLIENT_CALL time ms (RemoteClient.java line 166 RemoteServer.LKKKKuser) - brock added this because it annoyed him at some point: " + diff);
        if (diff > maxKickOutTime) {
            maxKickOutTime = diff;
            System.err.println("Max_KICKOUT_CLIENT_CALL time user (RemoteClient.java line 166 RemoteServer.LKKKKuser) - brock added this because it annoyed him at some point: " + charName);
            System.err.println("Max_KICKOUT_CLIENT_CALL time ms (RemoteClient.java line 166 RemoteServer.LKKKKuser) - brock added this because it annoyed him at some point: " + maxKickOutTime);
        }
    }
}
