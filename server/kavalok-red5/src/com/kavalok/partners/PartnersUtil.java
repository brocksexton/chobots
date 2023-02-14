package com.kavalok.partners;

import java.util.ArrayList;

import org.hibernate.NonUniqueResultException;

import com.eaio.uuid.UUID;
import com.kavalok.dao.BanDAO;
import com.kavalok.dao.LoginFromPartnerDAO;
import com.kavalok.dao.MarketingInfoDAO;
import com.kavalok.dao.PartnerDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.Ban;
import com.kavalok.db.LoginFromPartner;
import com.kavalok.db.MarketingInfo;
import com.kavalok.db.Partner;
import com.kavalok.db.User;
import com.kavalok.transactions.DefaultTransactionStrategy;
import com.kavalok.transactions.TransactionUtil;

public class PartnersUtil extends DefaultTransactionStrategy {
  //private static final String LOGIN_FORMAT = "[%1$s]%2$s";

  public String processLoginFromPartner(String partner, String password, String user, String email, String chatMode)
      throws IllegalArgumentException {
    ArrayList<Object> args = new ArrayList<Object>();
    args.add(partner);
    args.add(password);
    args.add(user);
    args.add(email);
    args.add(chatMode == null ? "safe" : chatMode);
    return (String) TransactionUtil.callTransaction(this, "doProcessLoginFromPartner", args);
  }

  public String doProcessLoginFromPartner(String partnerLogin, String password, String userName, String email,
      String chatMode) {
    Partner partner = new PartnerDAO(getSession()).findByLogin(partnerLogin);
    if (!partner.getPassword().equals(password))
      throw new IllegalArgumentException("Password is invalid");

    String userLogin = userName;// commented for zapak
    // String.format(LOGIN_FORMAT,
    // partner.getLogin(), userName);
    UserDAO userDAO = new UserDAO(getSession());
    User user = userDAO.findByLogin(userLogin);
    if (user == null) {
      user = new User();
      user.setLogin(userLogin);
      UUID passwordUuid = new UUID();
      user.setPassword(passwordUuid.toString());
      user.setEmail(email);
      user.setDeleted(false);
      user.setShowTips(true);
      MarketingInfo info = new MarketingInfo();
      info.setPartner(partner);
      new MarketingInfoDAO(getSession()).makePersistent(info);
      user.setMarketingInfo(info);
      user.setChatEnabled("full".equals(chatMode));
      userDAO.makePersistent(user);

      BanDAO banDAO = new BanDAO(getSession());
      Ban ban = new Ban();
      ban.setUser(user);
      ban.setChatEnabled("full".equals(chatMode));
      banDAO.makePersistent(ban);

    }
    if (!user.getMarketingInfo().getPartner().equals(partner))
      throw new IllegalArgumentException("User is registered to other partner");

    LoginFromPartnerDAO loginFromPartnerDAO = new LoginFromPartnerDAO(getSession());
    String result = new UUID().toString();
    LoginFromPartner loginFromPartner = null;

    try {
      loginFromPartner = loginFromPartnerDAO.findByUser(user);
    } catch (NonUniqueResultException e) {
      loginFromPartnerDAO.cleanUp(user);
    }

    if (loginFromPartner == null)
      loginFromPartner = new LoginFromPartner();

    loginFromPartner.setUser(user);
    loginFromPartner.setUid(result);
    loginFromPartnerDAO.makePersistent(loginFromPartner);
    return result;
  }
}
