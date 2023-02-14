package com.kavalok.messages;

import java.util.HashMap;
import java.util.Map;

import org.hibernate.Session;

import com.kavalok.dao.UserDAO;
import com.kavalok.db.User;

public class UsersCache {

  private static UsersCache instance = new UsersCache();

  private Map<Long, String> userLoginCache = new HashMap<Long, String>();

  private Map<Long, Long> userInvitedByCache = new HashMap<Long, Long>();

  private Map<Long, Long> userGameCharIdCache = new HashMap<Long, Long>();

  public static UsersCache getInstance() {
    return instance;
  }

  private void putUserLogin(User user) {
    userLoginCache.put(user.getId(), user.getLogin());
  }

  private void putUserGameCharId(User user) {
    userGameCharIdCache.put(user.getId(), user.getGameChar_id());
  }

  private void putUserInvitedBy(User user) {
    User invitedBy = user.getInvitedBy();
    if (invitedBy != null) {
      userInvitedByCache.put(user.getId(), invitedBy.getId());
    }
  }

  public void removeUser(Long userId) {
    userLoginCache.remove(userId);
    userInvitedByCache.remove(userId);
    userGameCharIdCache.remove(userId);
  }

  public Long getInvitedBy(Long userId, Session session) {
    Long result = userInvitedByCache.get(userId);
    if (result == null) {
      User user = new UserDAO(session).findById(userId);
      putCachedInfo(user);
      result = userInvitedByCache.get(userId);
    }
    return result;
  }

  public Long getInvitedBy(User user) {
    Long result = userInvitedByCache.get(user.getId());
    if (result == null) {
      putCachedInfo(user);
      result = userInvitedByCache.get(user.getId());
    }
    return result;
  }

  public String getLogin(Long userId, Session session) {
    String result = userLoginCache.get(userId);
    if (result == null) {
      User user = new UserDAO(session).findById(userId);
      putCachedInfo(user);
      result = user.getLogin();
    }
    return result;
  }

  public Long getGameCharId(Long userId, Session session) {
    Long result = userGameCharIdCache.get(userId);
    if (result == null) {
      User user = new UserDAO(session).findById(userId);
      putCachedInfo(user);
      result = user.getGameChar_id();
    }
    return result;
  }

  private void putCachedInfo(User user) {
    putUserLogin(user);
    putUserInvitedBy(user);
    putUserGameCharId(user);
  }
}
