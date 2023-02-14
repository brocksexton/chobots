package com.kavalok.db;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

import com.kavalok.permissions.AccessUser;
import com.kavalok.utils.StringUtil;

@Entity
public class User extends LoginModelBase {

    private String email;

    private boolean enabled = true;

    private boolean baned = false;

    private String banReason;

    private String charInfo;

    private boolean chatEnabled = true; // used to control chat by parent
    private boolean pictureChat = true;

    private boolean helpEnabled = true;

    private User invitedBy;

    private GameChar gameChar;

    private MarketingInfo marketingInfo;

    private boolean parent;

    private boolean agent;

    private boolean merchant;

    private boolean resetPass;

    private boolean defaultFrame;

    private String nameHistory;

    private boolean artist;


    private boolean journalist;

    private boolean eliteJournalist;

    private boolean darkness;

    private boolean moderator;

    private boolean forumer;


    private boolean publicLocation;

    // private boolean boughtbody;

    private boolean test;

    private boolean staff;

    private boolean dev;

    private boolean des;

    private boolean support;

    private boolean scout;

    private String charBadges = "";

    private String status = "default";

    private Integer exp = 1;

    private Integer uiCol = 26367;

    private Integer charLevel = 1;

    private String chatLog = null;

    private String team = "undefined";

    private String altAcc = "";

    private String purchasedBubbles = "none";

    private String purchasedCards = "none";

    private String permissions = "";

    private String location = null;

    private String purchasedBodies = "none";

    private Integer bankMoney = 0;

    private String accessToken = "notoken";

    private String twitterName = "noname";

    private String accessTokenSecret = "notoken";

    private String accToken;

    private String accTokenSecret;

    private String blog;

    private Boolean guest = false;

    private String activationKey;

    private String locale;

    private Date citizenExpirationDate;

    private Date banDate;

    private int citizenTryCount;

    private Boolean activated;

    private Boolean acceptRequests = true;

    private Boolean drawEnabled = true;

    private String blogURL;

    private int soundVolume = 50;

    private String badgeNum = "000";

    //private String encryptedPassword:String;

    private int musicVolume = 50;

    private Boolean showTips = false;

    private Boolean deleted;

    private List<UserDance> dances;

    private MembershipInfo membershipInfo;

    private UserExtraInfo userExtraInfo;

    private List<User> friends = new ArrayList<User>();

    private Boolean superUser = false;

    private RobotTeam robotTeam;

    private Crew crew;

    private Long robotTeam_id;

    private Long crew_id;

    private Long gameChar_id;

    private int homeRep = 0;

    private String homeCrit = "none,";

    private String privkey;


    public User() {
        super();
    }

    public User(Long id) {
        super();
        this.setId(id);
    }

    public User(Long id, String login) {
        super();
        this.setId(id);
        this.setLogin(login);
    }

    public User(String login, String password) {
        super();
        setLogin(login);
        setPassword(password);
    }

    @SuppressWarnings("unchecked")
    @Override
    @Transient
    public Class getAccessType() {
        return AccessUser.class;
    }

    @NotNull
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @OneToOne(fetch = FetchType.LAZY)
    public GameChar getGameChar() {
        return gameChar;
    }

    @Transient
    public GameChar getGameCharIdentifier() {
        if (getGameChar_id() == null)
            return null;
        GameChar result = new GameChar();
        result.setId(getGameChar_id());
        return result;
    }

    public void setGameChar(GameChar character) {
        this.gameChar = character;
    }

    @Column(columnDefinition = "boolean default true")
    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    @Column(columnDefinition = "boolean default true")
    public boolean isChatEnabled() {
        return chatEnabled;
    }

    public void setChatEnabled(boolean chatEnabled) {
        this.chatEnabled = chatEnabled;
    }

    @Column(columnDefinition = "boolean default true")
    public boolean isPictureChat() {
        return pictureChat;
    }

    public void setPictureChat(boolean pictureChat) {
        this.pictureChat = pictureChat;
    }

    @Column(columnDefinition = "boolean default true")
    public boolean isHelpEnabled() {
        return helpEnabled;
    }

    public void setHelpEnabled(boolean helpEnabled) {
        this.helpEnabled = helpEnabled;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isBaned() {
        return baned;
    }

    public void setBaned(boolean baned) {
        this.baned = baned;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isParent() {
        return parent;
    }

    public void setParent(boolean parent) {
        this.parent = parent;
    }

    @Transient
    public Boolean isActive() {
        return (activated == null) ? StringUtil.isEmptyOrNull(getActivationKey()) : activated;
    }

    public String getActivationKey() {
        return activationKey;
    }

    public void setActivationKey(String activationKey) {
        this.activationKey = activationKey;
    }

    public String getLocale() {
        return locale;
    }

    public void setLocale(String locale) {
        this.locale = locale;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isAgent() {
        return agent;
    }

    public void setAgent(boolean agent) {
        this.agent = agent;
    }

      @Column(columnDefinition = "boolean default false")
    public boolean isMerchant() {
        return merchant;
    }

    public void setMerchant(boolean merchant) {
        this.merchant = merchant;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isResetPass() {
        return resetPass;
    }

    public void setResetPass(boolean resetPass) {
        this.resetPass = resetPass;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isDefaultFrame() {
        return defaultFrame;
    }

    public void setDefaultFrame(boolean defaultFrame) {
        this.defaultFrame = defaultFrame;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isDarkness() {
        return darkness;
    }

    public void setDarkness(boolean darkness) {
        this.darkness = darkness;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isArtist() {
        return artist;
    }

    public void setArtist(boolean artist) {
        this.artist = artist;
    }


    @Column(columnDefinition = "boolean default false")
    public boolean isJournalist() {
        return journalist;
    }

    public void setJournalist(boolean journalist) {
        this.journalist = journalist;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isEliteJournalist() {
        return eliteJournalist;
    }

    public void setEliteJournalist(boolean journalist) {
        this.eliteJournalist = journalist;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isSupport() {
        return support;
    }

    public void setSupport(boolean support) {
        this.support = support;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isScout() {
        return scout;
    }

    public void setScout(boolean scout) {
        this.scout = scout;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isDev() {
        return dev;
    }

    public void setDev(boolean dev) {
        this.dev = dev;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isDes() {
        return des;
    }

    public void setDes(boolean des) {
        this.des = des;
    }

    public String isBlog() {
        return blog;
    }

    public void setBlog(String blog) {
        this.blog = blog;
    }

    public String getNameHistory() {
        return nameHistory;
    }

    public void setNameHistory(String nameHistory) {
        this.nameHistory = nameHistory;
    }


    @Column(nullable = false, columnDefinition = "int(6) default 1")
    public Integer getExperience() {
        return exp;
    }

    public void setExperience(int exp) {
        this.exp = exp;
    }

    @Column(nullable = false, columnDefinition = "int(6) default 0")
    public Integer getHomeRep() {
        return homeRep;
    }

    public void setHomeRep(int homeRep) {
        this.homeRep = homeRep;
    }


    @Column(nullable = false, columnDefinition = "int(17) default 26367")
    public Integer getUIColour() {
        return uiCol;
    }

    public void setUIColour(int uiColour) {
        this.uiCol = uiColour;
    }

    @Column(nullable = false, columnDefinition = "int(6) default 1")
    public Integer getCharLevel() {
        return charLevel;
    }

    public void setCharLevel(int charLevel) {
        this.charLevel = charLevel;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public void setChatLog(String chatLog) {
        this.chatLog = chatLog;
    }

    public void setPurchasedBubbles(String purchasedBubbles) {
        this.purchasedBubbles = purchasedBubbles;
    }

    public void setPrivKey(String privKey) {
        this.privkey = privKey;
    }

    public void setPurchasedCards(String purchasedCards) {
        this.purchasedCards = purchasedCards;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCharBadges(String charBadges) {
        this.charBadges = charBadges;
    }

    public String getCharBadges() {
        return charBadges;
    }

    public void setTeam(String team) {
        this.team = team;
    }

    public void setAltAcc(String altAcc) {
        this.altAcc = altAcc;
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions;
    }

    public void setLocation(String location) {
        this.location = location;
    }

//public void setEncryptedPassword(String encryptedPassword){
    //this.encryptedPassword = encryptedPassword;
//}


    public void setPurchasedBodies(String purchasedBodies) {
        this.purchasedBodies = purchasedBodies;
    }

    public void setHomeCrit(String homeCrit) {
        this.homeCrit = homeCrit;
    }

    public void setBankMoney(Integer bankMoney) {
        this.bankMoney = bankMoney;
    }

    public void setTwitterName(String twitterName) {
        this.twitterName = twitterName;
    }


    public void setAccessTokenSecret(String accessTokenSecret) {
        this.accessTokenSecret = accessTokenSecret;
    }

    public String getaccessToken() {
        return accessToken;
    }

    public String getChatLog() {
        return chatLog;
    }

    public String getPurchasedBubbles() {
        return purchasedBubbles;
    }

    public String getPrivKey() {
        return privkey;
    }

    public String getPurchasedCards() {
        return purchasedCards;
    }

    public String getStatus() {
        return status;
    }

    public String getTeam() {
        return team;
    }

    public String getAltAcc() {
        return altAcc;
    }

    public String getPermissions() {
        return permissions;
    }

    public String getLocation() {
        return location;
    }

//public String getEncryptedPassword(){
//  return encryptedPassword;
//}

    public String getPurchasedBodies() {
        return purchasedBodies;
    }

    @NotNull
    public String getHomeCrit() {
        return homeCrit;
    }

    public Integer getBankMoney() {
        return bankMoney;
    }

    public String getTwitterName() {
        return twitterName;
    }

    public String getaccessTokenSecret() {
        return accessTokenSecret;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isModerator() {
        return moderator;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isForumer() {
        return forumer;
    }


    @Column(columnDefinition = "boolean default false")
    public boolean getPublicLocation() {
        return publicLocation;
    }


    @Column(columnDefinition = "boolean default false")
    public boolean isStaff() {
        return staff;
    }

    public void setModerator(boolean moderator) {
        this.moderator = moderator;
    }

    public void setForumer(boolean forumer) {
        this.forumer = forumer;
    }

    public void setPublicLocation(boolean publicLocation) {
        this.publicLocation = publicLocation;
    }


    public void setStaff(boolean staff) {
        this.staff = staff;
    }

    @Column(columnDefinition = "boolean default false")
    public boolean isTest() {
        return test;
    }

    public void setTest(boolean test) {
        this.test = test;
    }

    @OneToOne(fetch = FetchType.LAZY)
    public MarketingInfo getMarketingInfo() {
        return marketingInfo;
    }

    public void setMarketingInfo(MarketingInfo marketingInfo) {
        this.marketingInfo = marketingInfo;
    }

    public Date getCitizenExpirationDate() {
        return citizenExpirationDate;
    }

    public void setCitizenExpirationDate(Date citizenExpirationDate) {
        this.citizenExpirationDate = citizenExpirationDate;
    }

    public Date getBanDate() {
        return banDate;
    }

    public void setBanDate(Date banDate) {
        this.banDate = banDate;
    }

    @Column(columnDefinition = "boolean default true")
    public Boolean getAcceptRequests() {
        return acceptRequests;
    }

    public void setAcceptRequests(Boolean acceptPrivateMessages) {
        this.acceptRequests = acceptPrivateMessages;
    }

    @Column(columnDefinition = "boolean default true")
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

    @Transient
    public boolean isCitizen() {
        return citizenExpirationDate != null && citizenExpirationDate.after(new Date());
    }

    @Transient
    public boolean isBanDate() {
        return banDate != null && banDate.after(new Date());
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

    @Column(nullable = false, columnDefinition = "int(11) default 0")
    public int getCitizenTryCount() {
        return citizenTryCount;
    }

    public void setCitizenTryCount(int citizenTryCount) {
        this.citizenTryCount = citizenTryCount;
    }

    @Column(columnDefinition = "boolean default false")
    public Boolean getActivated() {
        return activated;
    }

    public void setActivated(Boolean active) {
        this.activated = (active == null) ? StringUtil.isEmptyOrNull(getActivationKey()) : active;
    }


    public Boolean getGuest() {
        return guest;
    }

    public void setGuest(Boolean guest) {
        this.guest = guest == null ? false : guest;
    }

    @Column(nullable = false, columnDefinition = "int(3) default 50")
    public int getSoundVolume() {
        return soundVolume;
    }

    public void setSoundVolume(int soundVolume) {
        this.soundVolume = soundVolume;
    }

    public String getBadgeNum() {
        return badgeNum;
    }

    public void setBadgeNum(String badgeNum) {
        this.badgeNum = badgeNum;
    }

    @Column(nullable = false, columnDefinition = "int(3) default 50")
    public int getMusicVolume() {
        return musicVolume;
    }

    public void setMusicVolume(int musicVolume) {
        this.musicVolume = musicVolume;
    }

    @Column(nullable = false, columnDefinition = "bit(3) default true")
    public Boolean getShowTips() {
        return showTips;
    }

    public void setShowTips(Boolean showTips) {
        this.showTips = showTips;
    }

    @OneToOne(fetch = FetchType.LAZY)
    public User getInvitedBy() {
        return invitedBy;
    }

    public void setInvitedBy(User invitedBy) {
        this.invitedBy = invitedBy;
    }

    @Column(nullable = false, columnDefinition = "bit(3) default false")
    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    @OneToOne(fetch = FetchType.LAZY)
    public MembershipInfo getMembershipInfo() {
        return membershipInfo;
    }

    public void setMembershipInfo(MembershipInfo membershipInfo) {
        this.membershipInfo = membershipInfo;
    }

    @OneToOne(fetch = FetchType.LAZY)
    public UserExtraInfo getUserExtraInfo() {
        return userExtraInfo;
    }

    public void setUserExtraInfo(UserExtraInfo userExtraInfo) {
        this.userExtraInfo = userExtraInfo;
    }

    @Transient
    public List<String> getDancesData() {
        List<String> result = new ArrayList<String>();
        for (UserDance dance : getDances()) {
            result.add(dance.getDance());
        }
        return result;
    }

    @OneToMany(fetch = FetchType.LAZY)
    public List<UserDance> getDances() {
        return dances;
    }

    public void setDances(List<UserDance> dances) {
        this.dances = dances;
    }

    @NotNull
    @ManyToMany(fetch = FetchType.LAZY)
    public List<User> getFriends() {
        return friends;
    }

    public void setFriends(List<User> friends) {
        this.friends = friends;
    }

    @Column(nullable = false, columnDefinition = "bit(3) default false")
    public Boolean getSuperUser() {
        return superUser;
    }

    public void setSuperUser(Boolean superUser) {
        this.superUser = superUser;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    public RobotTeam getRobotTeam() {
        return robotTeam;
    }

    public void setRobotTeam(RobotTeam robotTeam) {
        this.robotTeam = robotTeam;
    }

    @Column(insertable = false, updatable = false)
    public Long getRobotTeam_id() {
        return robotTeam_id;
    }

    public void setRobotTeam_id(Long robotTeam_id) {
        this.robotTeam_id = robotTeam_id;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    public Crew getCrew() {
        return crew;
    }

    public void setCrew(Crew crew) {
        this.crew = crew;
    }

    @Column(insertable = false, updatable = false)
    public Long getCrew_id() {
        return crew_id;
    }

    public void setCrew_id(Long crew_id) {
        this.crew_id = crew_id;
    }

    @Column(insertable = false, updatable = false)
    public Long getGameChar_id() {
        return gameChar_id;
    }

    public void setGameChar_id(Long gameChar_id) {
        this.gameChar_id = gameChar_id;
    }

}
