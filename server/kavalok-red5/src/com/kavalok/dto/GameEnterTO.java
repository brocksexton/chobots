package com.kavalok.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.lang.*;

import org.red5.io.utils.ObjectMap;

import com.kavalok.dto.friend.FriendTO;
import com.kavalok.dto.pet.PetTO;
import com.kavalok.dto.robot.RobotTO;

import com.kavalok.dto.stuff.StuffItemLightTO;

public class GameEnterTO extends KeysTO {

  private Long  userId;
  private Long  age;
  private String remoteId;
  private Boolean chatEnabled = true;
  private Boolean pictureChat = true;
  private Boolean membershipChatDisabled = false;
  private Boolean serverInSafeMode = false;
  private Boolean drawingMode = false;
  private Boolean nonCitizenChatDisabled = false;
  private String chatEnabledByParent = "true";
  private Long chatBanLeftTime = null;
  private Boolean helpEnabled = true;
  private Boolean isGuest = false;
  private String email;
  private Boolean isAgent = false;
  private Boolean isMerchant = false;
  private Boolean isResetPass = false;
  private Boolean isDefaultFrame = false;
  private Boolean isCitizen = false;
  private Boolean isArtist = false;
  private Boolean isJournalist = false;
  private Boolean isEliteJournalist = false;
  private Boolean isScout = false;
  private Boolean isDev = false;
  private Boolean isDes = false;
  private Integer experience = null;
  private Integer uiColour = null;
  private Integer check1 = null;
  private Integer check2 = null;
  private Integer check3 = null;
  private Integer charLevel = null;
  private String chatLog;
  private String purchasedBubbles;
  private String purchasedCards;
  private String permissions;
  private String achievements;
  private String challenges;
  private String location;
  private String purchasedBodies;
  private String outfits;
  private Integer bankMoney;
  private String accessToken;
  private String twitterName;
  private String accessTokenSecret;
  private String  isBlog;
  private Integer lastOnlineDay;
  private boolean isSupport = false;
  private Date citizenExpirationDate = null;
  private Integer citizenTryCount = null;
  private String isModerator = "enter";
  private Boolean isForumer = false;
  private Boolean publicLocation = false;
  private Boolean isStaff = false;
  private String status;
  private Boolean isParent = true;
  private Boolean firstLogin = false;
  private String body = "default";
  private String gender;
  private String chatColor;
  private String blogLink;
  private Integer color = 0x9191C8;
  private Double money = 0d;
  private Double emeralds = 0d;
  private Double candy = 0d;
  private List<String> dances;
  private List<StuffItemLightTO> stuffs = new ArrayList<StuffItemLightTO>();
  private List<String> friends = new ArrayList<String>();
  private List<String> ignoreList = new ArrayList<String>();
  private List<ObjectMap<String, Object>> commands = new ArrayList<ObjectMap<String, Object>>();
  private Boolean notActivated = false;
  private PetTO pet = null;
  private List<Object> quests = new ArrayList<Object>();
  private Date created = new Date();
  private String drawEnabled = "false";
  private String blogURL;
  private Boolean acceptRequests = true;
  private Boolean acceptNight = true;
  private int soundVolume = 40;
  private int musicVolume = 20;
  private Boolean showTips = false;
  private Boolean showCharNames;
  private Date serverTime;
  private Boolean finishingNotification;
  private Boolean finishedNotification;
  private Boolean superUser = false;
  private StuffItemLightTO playerCard;
  private String privKey;
  
  private RobotTO robot = null;
  private List<FriendTO> robotTeam = null;
  private List<FriendTO> crew = null;
  private Integer teamColor = 0;
  private Integer crewColor = 0;
  
  public int getSoundVolume() {
    return soundVolume;
  }

  public void setSoundVolume(int soundVolume) {
    this.soundVolume = soundVolume;
  }


  public int getMusicVolume() {
    return musicVolume;
  }

  public void setMusicVolume(int musicVolume) {
    this.musicVolume = musicVolume;
  }

  public Boolean getShowTips() {
    return showTips;
  }

  public void setShowTips(Boolean showTips) {
    this.showTips = showTips;
  }

  public String getRemoteId() {
    return remoteId;
  }

  public void setRemoteId(String remoteId) {
    this.remoteId = remoteId;
  }

  public Boolean getChatEnabled() {
    return chatEnabled;
  }

  public void setChatEnabled(Boolean chatEnabled) {
    this.chatEnabled = chatEnabled;
  }

  public Boolean getPictureChat(){
    return pictureChat;
  }

  public void setPictureChat(Boolean pictureChat){
    this.pictureChat = pictureChat;
  }

  public Long getChatBanLeftTime() {
    return chatBanLeftTime;
  }

  public void setChatBanLeftTime(Long chatBanLeftTime) {
    this.chatBanLeftTime = chatBanLeftTime;
  }

  public Boolean getHelpEnabled() {
    return helpEnabled;
  }

  public void setHelpEnabled(Boolean helpEnabled) {
    this.helpEnabled = helpEnabled;
  }

  public Boolean getIsGuest() {
    return isGuest;
  }

  public void setIsGuest(Boolean isGuest) {
    this.isGuest = isGuest;
  }

  public String getEmail() {
    return email;
  }

  public String getPrivKey(){
    return privKey;
  }

  public void setPrivKey(String privKey){
    this.privKey = privKey;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }


  public Boolean getIsAgent() {
    return isAgent;
  }

  public void setIsAgent(Boolean isAgent) {
    this.isAgent = isAgent;
  }


  public Boolean getIsMerchant() {
    return isMerchant;
  }

  public void setIsMerchant(Boolean isMerchant) {
    this.isMerchant = isMerchant;
  }


  public Boolean getIsResetPass() {
    return isResetPass;
  }

  public void setIsResetPass(Boolean isResetPass) {
    this.isResetPass = isResetPass;
  }
  public Boolean getIsDefaultFrame() {
    return isDefaultFrame;
  }

  public void setIsDefaultFrame(Boolean isDefaultFrame) {
    this.isDefaultFrame = isDefaultFrame;
  }

public Boolean getIsArtist() {
    return isArtist;
  }

  public void setIsArtist(Boolean isArtist) {
    this.isArtist = isArtist;
  }

public Boolean getIsJournalist() {
    return isJournalist;
  }

  public void setIsJournalist(Boolean isJournalist) {
    this.isJournalist = isJournalist;
  }

  public Boolean getIsEliteJournalist() {
    return isEliteJournalist;
  }

  public void setIsEliteJournalist(Boolean isJournalist) {
    this.isEliteJournalist = isJournalist;
  }

  public boolean getIsSupport() {
	return isSupport;
}

  public void setIsSupport(Boolean isSupport){
	this.isSupport = isSupport;
	
}

  public boolean getIsScout() {
  return isScout;
}

  public void setIsScout(Boolean isScout){
  this.isScout = isScout;
  
}

public Boolean getIsDev() {
    return isDev;
  }

  public void setIsDev(Boolean isDev) {
    this.isDev = isDev;
  }
public Boolean getIsDes() {
    return isDes;
  }

  public void setIsDes(Boolean isDes) {
    this.isDes = isDes;
  }

 public Boolean getIsStaff() {
    return isStaff;
  }

  public void setIsStaff(Boolean isStaff) {
    this.isStaff = isStaff;
  }

  public Boolean getIsCitizen() {
    return isCitizen;
  }

  public void setIsCitizen(Boolean isCitizen) {
    this.isCitizen = isCitizen;
  }


public Integer getExperience() {
    return experience;
  }

  public Integer getUIColour(){
    return uiColour;
  }
  public Integer getCheck1(){
    return check1;
  }
  public Integer getCheck2(){
    return check2;
  }
  public Integer getCheck3(){
    return check3;
  }

public Integer getCharLevel() {
	return charLevel;
}


public String getChatLog() {
	return chatLog;
}

public String getPurchasedCards(){
  return purchasedCards;
}


public String getPurchasedBubbles(){
	return purchasedBubbles;
}

public String getPermissions(){
	return permissions;
}

public String getChallenges(){
	return challenges;
}

public String getAchievements(){
	return achievements;
}

public String getLocation(){
	return location;
}

public String getPurchasedBodies(){
	return purchasedBodies;
}
public String getOutfits(){
	return outfits;
}
public Integer getBankMoney(){
	return bankMoney;
}
public void setWhatPurchasedBubbles(String purchasedBubbles)
{
	this.purchasedBubbles = purchasedBubbles;
}

public void setWhatPurchasedCards(String purchasedCards)
{
  this.purchasedCards = purchasedCards;
}

public void setWhatPermissions(String permissions)
{
	this.permissions = permissions;
}

public void setWhatAchievements(String achievements)
{
	this.achievements = achievements;
}

public void setWhatChallenges(String challenges)
{
	this.challenges = challenges;
}

public void setWhatLocation(String location)
{
	this.location = location;
}

public void setWhatPurchasedBodies(String purchasedBodies)
{
	this.purchasedBodies = purchasedBodies;
}

public void setWhatOutfits(String outfits)
{
	this.outfits = outfits;
}
public void setWhatBankMoney(Integer bankMoney){
	this.bankMoney = bankMoney;
}
public void setWhatLevel(Integer charLevel){
	this.charLevel = charLevel;
}

public void setWhatChatLog(String chatLog){
	this.chatLog = chatLog;
}



public String getaccessToken() {
   return accessToken;
}

public String getTwitterName(){
	return twitterName;
}

public String getaccessTokenSecret() {
   return accessTokenSecret;
}

  public void setWhatExperience(Integer experience) {
    this.experience = experience;
  }

  public void setWhatUIColour(Integer uiColour){
    this.uiColour = uiColour;
  }
  
  public void setWhatCheck1(Integer check1){
    this.check1 = check1;
  }
  
  public void setWhatCheck2(Integer check2){
    this.check2 = check2;
  }
  
  public void setWhatCheck3(Integer check3){
    this.check3 = check3;
  }

public void setWhatAccessToken(String accessToken) {
	this.accessToken = accessToken;
}

public void setWhatAccessTokenSecret(String accessTokenSecret){
	this.accessTokenSecret = accessTokenSecret;
}

public void setWhatTwitterName(String twitterName){
	this.twitterName = twitterName;
}
public String getIsBlog() {
    return isBlog;
  }

  public void setIsBlog(String isBlog) {
    this.isBlog = isBlog;
  }

  public Integer getLastOnlineDay(){
    return lastOnlineDay;
  }
  public void setLastOnlineDay(Integer lastOnlineDay){
    this.lastOnlineDay = lastOnlineDay;
  }

  public Date getCitizenExpirationDate() {
    return citizenExpirationDate;
  }

  public void setCitizenExpirationDate(Date citizenExpirationDate) {
    this.citizenExpirationDate = citizenExpirationDate;
  }

  public String getIsModerator() {
    return isModerator;
  }
  public Boolean getIsForumer(){
    return isForumer;
  }
  public Boolean getPublicLocation(){
	return publicLocation;
}
  public void setIsModerator(String isModerator) {
    this.isModerator = isModerator;
  }
  public void setIsForumer(Boolean isForumer){
    this.isForumer = isForumer;
  }
  public void setWhatPublicLocation(Boolean publicLocation) {
    this.publicLocation = publicLocation;
  }


  public Boolean getIsParent() {
    return isParent;
  }

  public void setIsParent(Boolean isParent) {
    this.isParent = isParent;
  }

  public Boolean getFirstLogin() {
    return firstLogin;
  }

  public void setFirstLogin(Boolean firstLogin) {
    this.firstLogin = firstLogin;
  }

  public String getBody() {
    return body;
  }

  public void setBody(String body) {
    this.body = body;
  }

 public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

 public String getChatColor() {
    return chatColor;
  }

  public void setChatColor(String chatColor) {
    this.chatColor = chatColor;
  }

 public String getBlogLink() {
    return blogLink;
  }

  public void setBlogLink(String blogLink) {
    this.blogLink = blogLink;
  }

  public Double getMoney() {
    return money;
  }

  public void setMoney(Double money) {
    this.money = money;
  }



public Double getEmeralds() {
    System.err.println("Got emeralds as " + emeralds);
    return emeralds;
    //return new Double("6");
  }

  public void setEmeralds(Double emeralds) {
    System.err.println("Set emeralds as " + emeralds);
    this.emeralds = emeralds;
  }



    public Double getCandy() {
    return candy;
  }

  public void setCandy(Double candy) {
    this.candy = candy;
  }

  public List<StuffItemLightTO> getStuffs() {
    return stuffs;
  }

  public void setStuffs(List<StuffItemLightTO> stuffs) {
    this.stuffs = stuffs;
  }

  public List<String> getFriends() {
    return friends;
  }

  public void setFriends(List<String> friends) {
    this.friends = friends;
  }

  public List<String> getIgnoreList() {
    return ignoreList;
  }

  public void setIgnoreList(List<String> ignoreList) {
    this.ignoreList = ignoreList;
  }

  public List<ObjectMap<String, Object>> getCommands() {
    return commands;
  }

  public void setCommands(List<ObjectMap<String, Object>> commands) {
    this.commands = commands;
  }

  public Boolean getNotActivated() {
    return notActivated;
  }

  public void setNotActivated(Boolean notActivated) {
    this.notActivated = notActivated;
  }

  public PetTO getPet() {
    return pet;
  }

  public void setPet(PetTO pet) {
    this.pet = pet;
  }

  public List<Object> getQuests() {
    return quests;
  }

  public void setQuests(List<Object> quests) {
    this.quests = quests;
  }

  public Date getCreated() {
    return created;
  }

  public void setCreated(Date created) {
    this.created = created;
  }

  public String getDrawEnabled() {
    return drawEnabled;
  }

  public void setDrawEnabled(String drawEnabled) {
    this.drawEnabled = drawEnabled;
  }

  public String getBlogURL() {
    return blogURL;
  }

  public void setBlogURL(String blogURL) {
    this.blogURL = blogURL;
  }

  public Boolean getAcceptRequests() {
    return acceptRequests;
  }

  public void setAcceptRequests(Boolean acceptRequests) {
    this.acceptRequests = acceptRequests;
  }

  public Boolean getAcceptNight() {
    return acceptNight;
  }

  public void setAcceptNight(Boolean acceptNight) {
    this.acceptNight = acceptNight;
  }

  public String getChatEnabledByParent() {
    return chatEnabledByParent;
  }

  public void setChatEnabledByParent(String chatEnabledByParent) {
    this.chatEnabledByParent = chatEnabledByParent;
  }

  public Integer getCitizenTryCount() {
    return citizenTryCount;
  }

  public void setCitizenTryCount(Integer citizenTryCount) {
    this.citizenTryCount = citizenTryCount;
  }

  public Integer getColor() {
    return color;
  }

  public void setColor(Integer color) {
    this.color = color;
  }

  public Date getServerTime() {
    return serverTime;
  }

  public void setServerTime(Date serverTime) {
    this.serverTime = serverTime;
  }

  public Boolean getShowCharNames() {
    return showCharNames;
  }

  public void setShowCharNames(Boolean showCharNames) {
    this.showCharNames = showCharNames;
  }

  public Boolean getFinishingNotification() {
    return finishingNotification;
  }

  public void setFinishingNotification(Boolean finishingNotification) {
    this.finishingNotification = finishingNotification;
  }

  public Boolean getFinishedNotification() {
    return finishedNotification;
  }

  public void setFinishedNotification(Boolean finishedNotification) {
    this.finishedNotification = finishedNotification;
  }

  public List<String> getDances() {
    return dances;
  }

  public void setDances(List<String> dances) {
    this.dances = dances;
  }

  public Boolean getMembershipChatDisabled() {
    return membershipChatDisabled;
  }

  public void setMembershipChatDisabled(Boolean membershipChatDisabled) {
    this.membershipChatDisabled = membershipChatDisabled;
  }

  public Boolean getNonCitizenChatDisabled() {
    return nonCitizenChatDisabled;
  }

  public void setNonCitizenChatDisabled(Boolean nonCitizenChatDisabled) {
    this.nonCitizenChatDisabled = nonCitizenChatDisabled;
  }

  public Boolean getServerInSafeMode() {
    return serverInSafeMode;
  }

  public void setServerInSafeMode(Boolean serverInSafeMode) {
    this.serverInSafeMode = serverInSafeMode;
  }

public Boolean getDrawingMode() {
    return drawingMode;
  }

  public void setDrawingMode(Boolean drawingMode) {
    this.drawingMode = drawingMode;
  }

	public Boolean getSuperUser() {
		return superUser;
	}
	
	public void setSuperUser(Boolean superUser) {
		this.superUser = superUser;
	}

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

public StuffItemLightTO getPlayerCard() {
	return playerCard;
}

public void setPlayerCard(StuffItemLightTO stuffItemLightTO) {
	this.playerCard = stuffItemLightTO;
}

public RobotTO getRobot() {
	return robot;
}

public void setRobot(RobotTO robot) {
	this.robot = robot;
}

public List<FriendTO> getRobotTeam() {
	return robotTeam;
}

public void setRobotTeam(List<FriendTO> robotTeam) {
	this.robotTeam = robotTeam;
}

public List<FriendTO> getCrew(){
  return crew;
}

public void setCrew(List<FriendTO> crew){
this.crew = crew;
}

public Integer getTeamColor() {
	return teamColor;
}

public void setTeamColor(Integer teamColor) {
	this.teamColor = teamColor;
}

public Integer getCrewColor() {
  return crewColor;
}

public void setCrewColor(Integer crewColor) {
  this.crewColor = crewColor;
}

public Long getAge() {
  return age;
}

public void setAge(Long age) {
  this.age = age;
}

}
