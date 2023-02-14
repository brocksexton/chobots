package com.kavalok.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.BanDAO;
import com.kavalok.dao.BlackIPDAO;
import com.kavalok.dao.MembershipHistoryDAO;
import com.kavalok.dao.UserServerDAO;
import com.kavalok.db.Ban;
import com.kavalok.db.BlackIP;
import com.kavalok.db.GameChar;
import com.kavalok.db.MembershipHistory;
import com.kavalok.db.Server;
import com.kavalok.db.User;
import com.kavalok.db.UserExtraInfo;
import com.kavalok.services.BanUtil;
import com.kavalok.user.UserUtil;
import com.kavalok.xmlrpc.RemoteClient;

public class UserTO extends CharTO {

  public static ArrayList<UserTO> convertUsers(Session session, List<User> users) {
    ArrayList<UserTO> result = new ArrayList<UserTO>();
    for (User user : users) {
      UserTO to = convertUser(session, user, false);

      result.add(to);
    }
    return result;
  }

  public static UserTO convertUser(Session session, User user) {
    return convertUser(session, user, true);
  }

  public static UserTO convertUser(Session session, User user, boolean addDetails) {
    BanDAO banDAO = new BanDAO(session);
    BlackIPDAO blackIPDAO = new BlackIPDAO(session);
    Ban ban = banDAO.findByUser(user);
    if (ban == null) {
      ban = new Ban();
    }
    UserExtraInfo userExtraInfo = user.getUserExtraInfo();
    String lastIp = null;
    if(userExtraInfo!=null)
      lastIp = userExtraInfo.getLastIp();
    UserTO to = new UserTO(user, ban, blackIPDAO.findByIp(lastIp));

    if (to.getCitizenExpirationDate() != null) {
      MembershipHistoryDAO histDao = new MembershipHistoryDAO(session);
      List<MembershipHistory> histItems = histDao.findByEndDate(to.getCitizenExpirationDate());
      if (!histItems.isEmpty()) {
        // checking for old citizenships without history
        to.setCitizenStartDate(histItems.get(0).getCreated());
      }
    }
    if (BanUtil.getBanLeftTime(ban) <= 0) {
      to.setBanCount(0);
    }

    Server server = new UserServerDAO(session).getServer(user);
    if (server != null) {
      to.setServer(server.getName());
      String locations = new RemoteClient(session, user, server).getSharedObjects();
      to.setLocations(locations);
    }
    return to;
  }

  private String ip;

  private Date prevLogin;

  private String email;

  private Integer banCount;

  private Date banDate;

  private Date timeBan;

  private Date citizenExpirationDate;

  private Date citizenStartDate;

  private String locations;

  private Boolean activated;

  private String locale;

  private Boolean baned;

  private Boolean drawEnabled;

  private String blogURL;

  private String banReason;

  private String status;

  private String charInfo;

  private Boolean ipBaned;

  private Boolean deleted;


  public UserTO(User user, Ban ban, BlackIP blackIp) {
    super();
    setLogin(user.getLogin());
    setUserId(user.getId().intValue());
    email = user.getEmail();
    setChatEnabled(ban.isChatEnabled());
    setChatEnabledByParent(user.isChatEnabled());
    setPictureChat(user.isPictureChat());
    banCount = ban.getBanCount();
    banDate = ban.getBanDate();
    setEnabled(user.isEnabled());
    UserExtraInfo userExtraInfo = user.getUserExtraInfo();
    String lastIp = null;
    if(userExtraInfo!=null)
      lastIp = userExtraInfo.getLastIp();
    ip = lastIp;
    Date lastLogin = null;
    if(userExtraInfo!=null)
      lastLogin = userExtraInfo.getLastLoginDate();
    prevLogin = lastLogin;
    Long age = UserUtil.getAge(user);
    setAge(age.intValue());
    activated = user.isActive();
    locale = user.getLocale();
    setAgent(user.isAgent());
    setResetPass(user.isResetPass());
    setDefaultFrame(user.isDefaultFrame());
    setArtist(user.isArtist());
    setJournalist(user.isJournalist());
    setEliteJournalist(user.isEliteJournalist());
    setDev(user.isDev());
    setDes(user.isDes());
    setForumer(user.isForumer());
    setModerator(user.isModerator());
    setPublicLocation(user.getPublicLocation());
    setStaff(user.isStaff());
    setSupport(user.isSupport());
    setScout(user.isScout());
    setCitizen(user.isCitizen());
    setExperience(user.getExperience());  
    setUIColour(user.getUIColour());
    setCharLevel(user.getCharLevel()); 
    setChatLog(user.getChatLog());
    setStatus(user.getStatus());
    setPurchasedBubbles(user.getPurchasedBubbles());
    setPurchasedCards(user.getPurchasedCards());
    setPermissions(user.getPermissions());
    setLocation(user.getLocation());
    setPurchasedBodies(user.getPurchasedBodies());
    setBankMoney(user.getBankMoney());
	setaccessToken(user.getaccessToken());
	setTwitterName(user.getTwitterName());
	setaccessTokenSecret(user.getaccessTokenSecret());
    setBlog(user.isBlog());
    drawEnabled = user.getDrawEnabled();
    blogURL = user.getBlogURL();
    citizenExpirationDate = user.getCitizenExpirationDate();
    charInfo = user.getCharInfo();
    banReason = user.getBanReason();
    if (user.getBanReason() == null && blackIp != null && blackIp.isBaned()) {
      banReason = blackIp.getReason();
    }

    ipBaned = blackIp != null && blackIp.isBaned();
    baned = user.isBaned();
    timeBan = user.getBanDate();
    deleted = user.getDeleted();
    setParent(user.isParent());
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

    public Date getPrevLoginDate() {
    return prevLogin;
  }

  public void setPrevLoginDate(Date prevLogin) {
    this.prevLogin = prevLogin;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String mail) {
    this.email = mail;
  }

  public Integer getBanCount() {
    return banCount;
  }

  public void setBanCount(Integer banCount) {
    this.banCount = banCount;
  }

  public Date getBanDate() {
    return banDate;
  }

  public void setBanDate(Date banDate) {
    this.banDate = banDate;
  }

  public Date getCitizenExpirationDate() {
    return citizenExpirationDate;
  }

  public void setCitizenExpirationDate(Date citizenExpirationDate) {
    this.citizenExpirationDate = citizenExpirationDate;
  }

  public Date getCitizenStartDate() {
    return citizenStartDate;
  }

  public void setCitizenStartDate(Date citizenStartDate) {
    this.citizenStartDate = citizenStartDate;
  }

  public String getLocations() {
    return locations;
  }

  public void setLocations(String locations) {
    this.locations = locations;
  }
    public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Boolean getActivated() {
    return activated;
  }

  public void setActivated(Boolean activated) {
    this.activated = activated;
  }

  public String getLocale() {
    return locale;
  }

  public void setLocale(String locale) {
    this.locale = locale;
  }

  public Boolean getBaned() {
    return baned;
  }

  public void setBaned(Boolean baned) {
    this.baned = baned;
  }

  public Date getTimeBan(){
    return timeBan;
  }
  public void setTimeBan(Date timeBan){
    this.timeBan = timeBan;
  }

  public Boolean getDrawEnabled() {
    return drawEnabled;
  }

  public void setDrawEnabled(Boolean drawEnabled) {
    this.drawEnabled = drawEnabled;
  }
  public String getBlogURL() {
    return blogURL;
  }

  public void setBlogURL(String blogURL) {
    this.blogURL = blogURL;
  }

  public String getBanReason() {
    return banReason;
  }

  public void setBanReason(String banReason) {
    this.banReason = banReason;
  }

public String getCharInfo() {
    return charInfo;
  }

  public void setCharInfo(String charInfo) {
    this.charInfo = charInfo;
  }

  public Boolean getIpBaned() {
    return ipBaned;
  }

  public void setIpBaned(Boolean ipBaned) {
    this.ipBaned = ipBaned;
  }

  public Boolean getDeleted() {
    return deleted;
  }

  public void setDeleted(Boolean deleted) {
    this.deleted = deleted;
  }

}
