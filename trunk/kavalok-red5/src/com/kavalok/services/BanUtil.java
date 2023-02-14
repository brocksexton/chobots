package com.kavalok.services;

import java.util.Date;

import org.hibernate.Session;

import com.kavalok.dao.BanDAO;
import com.kavalok.db.Ban;
import com.kavalok.db.User;
import com.kavalok.user.UserAdapter;

public class BanUtil {
  //
  // private Ban getBan(Long userId) {
  // Ban ban = banDAO.findByUserId(userId);
  // return ban;
  // }
  //
  // public long getBanLeftTime(Long userId) {
  // Ban ban = getBan(userId);
  // return getBanLeftTime(ban);
  // }

  public static void disableChat(User user, Session session, UserAdapter adapter, String part) {
    BanDAO banDAO = new BanDAO(session);
    Ban ban = banDAO.findByUser(user);
    if (ban == null) {
      ban = new Ban();
      ban.setUser(user);
      ban.setChatEnabled(true);
    }
    ban.setBanDate(new Date());
    ban.setBanCount(ban.getBanCount() + 1);
    // if (ban.getBanCount() > 2) {
    // ban.setChatEnabled(false);
    // }

    if (ban.getBanCount() > 2) {
      ban.setBanCount(1);
    }
    
    long banLeftTime = getBanLeftTime(ban);
    
    adapter.disableChat(part, banLeftTime, getBanPeriod(ban));
    banDAO.makePersistent(ban);
  }

  public static int getBanPeriod(Ban ban) {
    int result = 0;
    int banCount = ban.getBanCount();
    switch (banCount) {
    case 1:
      result = 5;
      break;
    case 2:
      result = 15;
      break;
    case 3:
      result = 12 * 60; // 1 hour!
      break;
    default:
      break;
    }
    return result;
  }

  public static Long getBanLeftTime(Ban ban) {
    long result = 0;
    int banCount = ban.getBanCount();
    long now = System.currentTimeMillis();
    switch (banCount) {
    case 1:
      result = ban.getBanDate().getTime() + 5 * 60 * 1000 - now;
      //result = ban.getBanDate().getTime() + 1 * 5 * 1000 - now;
      break;
    case 2:
      result = ban.getBanDate().getTime() + 15 * 60 * 1000 - now;
      //result = ban.getBanDate().getTime() + 1 * 5 * 1000 - now;
      break;
    case 3:
      result = ban.getBanDate().getTime() + 12 * 60 * 60 * 1000 - now;
      //result = ban.getBanDate().getTime() + 1 * 5 * 1000 - now;
      break;
    default:
      break;
    }
    if (result < 0) {
      result = 0;
    }
    return result;
  }
  //
  // public Ban incrementBan(Long userId) {
  // Ban ban = getBan(userId);
  // if (ban == null) {
  // ban = new Ban();
  // }
  // if (ban.getBanCount() >= 2) {
  // ban.setChatEnabled(false);
  // } else {
  // ban.setBanCount(ban.getBanCount() + 1);
  // }
  // banDAO.makePersistent(ban);
  // return ban;
  // }
  //
  // public void updateChatEnabled(User user, boolean chatEnabled) {
  // BanDAO banDAO = new BanDAO(getSession());
  // Ban ban = banDAO.findByUserId(user.getId());
  // if (ban == null && chatEnabled) {
  // return;
  // }
  // if (!ban.isChatEnabled() && chatEnabled) {
  // ban.setChatEnabled(chatEnabled);
  // ban.setBanCount(0);
  // } else {
  // ban.setChatEnabled(chatEnabled);
  // }
  // banDAO.makePersistent(ban);
  // }
  //
  // public void updateChatEnabled(String userLogin, boolean chatEnabled) {
  // UserDAO userDAO = new UserDAO(getSession());
  // User user = userDAO.findByLogin(userLogin);
  // updateChatEnabled(user, chatEnabled);
  // }

}
