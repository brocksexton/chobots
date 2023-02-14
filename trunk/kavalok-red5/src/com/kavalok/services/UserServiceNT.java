package com.kavalok.services;

import com.kavalok.dao.BanDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.Ban;
import com.kavalok.db.User;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;
import com.kavalok.user.UserUtil;
import com.kavalok.xmlrpc.RemoteClient;

public class UserServiceNT extends DataServiceNotTransactionBase {

  public void setHelpEnabled(Boolean value) {
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
    if (adapter.getPersistent()) {
	    UserDAO userDAO = new UserDAO(getSession());
	    User user = userDAO.findById(adapter.getUserId());
	    user.setHelpEnabled(value);
	    userDAO.makePersistent(user);
    }
  }

  public void blockUserChat(Long userId) {
    UserDAO userDAO = new UserDAO(getSession());
    User user = userDAO.findById(userId);
    BanDAO banDAO = new BanDAO(getSession());
    Ban ban = banDAO.findByUser(user);
    if (ban == null) {
      ban = new Ban();
      ban.setChatEnabled(false);
    }
    banDAO.makePersistent(ban);
    new RemoteClient(getSession(), user).disableUserChat(ban.isChatEnabled(), user.isChatEnabled());
  }

  public Boolean userExists(String login) {
	  UserDAO userDAO = new UserDAO(getSession());
	  return userDAO.findByLogin(login) != null;
  }
  
  
  public void setLocale(String locale) {
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
    UserDAO userDAO = new UserDAO(getSession());
    User user = userDAO.findById(adapter.getUserId());
    user.setLocale(locale);
    userDAO.makePersistent(user);

  }
  public void tryCitizenship() {
//    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
//    UserUtil.tryCitizenship(getSession(), adapter.getUserId());
  }

  public Integer daysCanTryCitizenship() {
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
    return UserUtil.daysCanTryCitizenship(getSession(), adapter.getUserId());
  }

}
