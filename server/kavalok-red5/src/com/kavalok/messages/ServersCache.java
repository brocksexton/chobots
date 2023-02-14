package com.kavalok.messages;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.kavalok.db.Server;
import com.kavalok.db.UserServer;

public class ServersCache {

  private static ServersCache instance = new ServersCache();

  private Map<Long, String> serverNameCache = new ConcurrentHashMap<Long, String>();

  public static ServersCache getInstance() {
    return instance;
  }

  public void putServerName(Server server) {
    serverNameCache.put(server.getId(), server.getName());
  }

  public String getServerName(Long serverId) {
    String result = serverNameCache.get(serverId);
    return result;
  }

  public String getServerName(UserServer userServer) {
    if (userServer == null) {
      return null;
    }
    String result = serverNameCache.get(userServer.getServerId());
    if (result == null) {
      Server server = userServer.getServer();
      serverNameCache.put(server.getId(), server.getName());
      result = server.getName();
    }
    return result;
  }

  // public String getServerName(Session session, User user) {
  // if (user.getServer_id() == null) {
  // return null;
  // }
  // String result = serverNameCache.get(user.getServer_id());
  // if (result == null) {
  // Server server = user.getServer();
  // serverNameCache.put(server.getId(), server.getName());
  // result = server.getName();
  // }
  // return result;
  // }
}
