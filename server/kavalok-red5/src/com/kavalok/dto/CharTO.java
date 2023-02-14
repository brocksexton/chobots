package com.kavalok.dto;

import java.util.List;

import com.kavalok.dto.friend.FriendTO;
import com.kavalok.dto.stuff.StuffItemLightTO;

public class CharTO extends FriendTO {
  private String id;

  private String body;
 private String gender;
  private String blogLink;
  private String chatColor;
  private Integer color;
  private boolean chatEnabled;
  private boolean pictureChat;
  private boolean chatEnabledByParent;
  private Integer chatBanLeftTime;
  private boolean enabled;
  private boolean isParent;
  private boolean isCitizen;
  private boolean isGuest;
  private boolean isAgent;
  private boolean isMerchant;
  private boolean isResetPass;
  private boolean isDefaultFrame;
  private String location;
  private boolean isArtist;
  private boolean isJournalist;
  private boolean isEliteJournalist;
  private boolean isModerator;
  private boolean isForumer;
  private boolean publicLocation;
  private boolean isStaff;
  private boolean isScout;
  private boolean isOnline;
  private boolean isDev;
  private boolean isDes;
  private String team;
  private boolean isSupport;
  private String  isBlog;
  private Integer lastOnlineDay;
  private String blogURL;
  private String locale;
  private Integer age;
  private Integer experience;
  private Integer uiColour;
  private Integer check1;
  private Integer check2;
  private Integer check3;
  private Integer charLevel;
  private String chatLog;
private String purchasedBubbles;
private String purchasedCards;
private String charStatus;
 private String permissions;
 private String achievements;
 private String challenges;
  private String purchasedBodies;
  private String outfits;
  private Integer bankMoney;
  private String accessToken;
  private String twitterName;
  private String accessTokenSecret;
  private Boolean hasRobot;
  private String teamName;
  private int teamColor = 0;
  private String crewName;
  private int crewColor = 0;
  private boolean acceptRequests;
  private boolean acceptNight;
  private List<StuffItemLightTO> clothes;
  private StuffItemLightTO playerCard;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
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
   public String getStatus() {
    return charStatus;
  }

  public void setStatus(String status) {
    this.charStatus = status;
  }


  public boolean isChatEnabled() {
    return chatEnabled;
  }

  public void setChatEnabled(boolean chatEnabled) {
    this.chatEnabled = chatEnabled;
  }

  public boolean isPictureChat(){
    return pictureChat;
  }
  public void setPictureChat(boolean pictureChat){
    this.pictureChat = pictureChat;
  }
  public Integer getChatBanLeftTime() {
    return chatBanLeftTime;
  }

  public void setChatBanLeftTime(Integer chatBanLeftTime) {
    this.chatBanLeftTime = chatBanLeftTime;
  }

  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }

  public boolean isParent() {
    return isParent;
  }

  public void setParent(boolean isParent) {
    this.isParent = isParent;
  }

  public boolean isCitizen() {
    return isCitizen;
  }

  public void setCitizen(boolean isCitizen) {
    this.isCitizen = isCitizen;
  }

  public boolean isGuest() {
    return isGuest;
  }

  public void setGuest(boolean isGuest) {
    this.isGuest = isGuest;
  }

  public boolean isAgent() {
    return isAgent;
  }

  public void setAgent(boolean isAgent) {
    this.isAgent = isAgent;
  }


  public boolean isMerchant() {
    return isMerchant;
  }

  public void setMerchant(boolean isMerchant) {
    this.isMerchant = isMerchant;
  }

  public boolean isResetPass() {
    return isResetPass;
  }

  public void setResetPass(boolean isResetPass) {
    this.isResetPass = isResetPass;
  }
  
    public boolean isDefaultFrame() {
    return isDefaultFrame;
  }

  public void setDefaultFrame(boolean isDefaultFrame) {
    this.isDefaultFrame = isDefaultFrame;
  }

public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }

public boolean isArtist() {
    return isArtist;
  }

  public void setArtist(boolean isArtist) {
    this.isArtist = isArtist;
  }

public boolean isJournalist() {
    return isJournalist;
  }

  public void setJournalist(boolean isJournalist) {
    this.isJournalist = isJournalist;
  }

  public boolean isEliteJournalist() {
    return isEliteJournalist;
  }

  public void setEliteJournalist(boolean isJournalist) {
    this.isEliteJournalist = isJournalist;
  }

public boolean isSupport() {
    return isSupport;
  }

  public void setSupport(boolean isSupport) {
    this.isSupport = isSupport;
  }

public boolean isScout() {
    return isScout;
  }

  public void setScout(boolean isScout) {
    this.isScout = isScout;
  }

public boolean isDev() {
    return isDev;
  }

  public void setDev(boolean isDev) {
    this.isDev = isDev;
  }

public boolean isDes() {
    return isDes;
  }

  public void setDes(boolean isDes) {
    this.isDes = isDes;
  }


  public boolean isModerator() {
    return isModerator;
  }
  public boolean isForumer(){
    return isForumer;
  }
public boolean getPublicLocation(){
	return publicLocation;
}
  public String getTeam(){
	return team;
}
public boolean isStaff() {
    return isStaff;
  }

  public void setModerator(boolean isModerator) {
    this.isModerator = isModerator;
  }
  public void setForumer(boolean isForumer){
    this.isForumer = isForumer;
  }
  public void setPublicLocation(boolean publicLocation) {
    this.publicLocation = publicLocation;
  }

public void setTeam(String team){
	this.team = team;
}

public void setStaff(boolean isStaff) {
    this.isStaff = isStaff;
  }
  public boolean isOnline() {
    return isOnline;
  }

  public void setOnline(boolean isOnline) {
    this.isOnline = isOnline;
  }

  public String getLocale() {
    return locale;
  }

  public void setLocale(String locale) {
    this.locale = locale;
  }


  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  public boolean isAcceptRequests() {
    return acceptRequests;
  }

  public void setAcceptRequests(boolean acceptRequests) {
    this.acceptRequests = acceptRequests;
  }

  public boolean isAcceptNight() {
    return acceptNight;
  }

  public void setAcceptNight(boolean acceptNight) {
    this.acceptNight = acceptNight;
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

public String getPurchasedBubbles(){
	return purchasedBubbles;
}

public String getPurchasedCards(){
  return purchasedCards;
}

public String getPermissions(){
	return permissions;
}

public String getAchievements(){
	return achievements;
}

public String getChallenges(){
	return challenges;
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
public String getaccessToken() {
    return accessToken;
}

public String getTwitterName() {
	return twitterName;
}
public String getaccessTokenSecret() {
    return accessTokenSecret;
}

public void setaccessToken(String accessToken) {
   this.accessToken = accessToken;
}

public void setTwitterName(String twitterName) {
	this.twitterName = twitterName;
}

public void setaccessTokenSecret(String accessTokenSecret) {
  this.accessTokenSecret = accessTokenSecret;
}


  public void setExperience(Integer experience) {
    this.experience = experience;
  }

  public void setUIColour(Integer uiColour){
    this.uiColour = uiColour;
  }
  
  public void setCheck1(Integer check1){
    this.check1 = check1;
  }
  
  public void setCheck2(Integer check2){
    this.check2 = check2;
  }
  
  public void setCheck3(Integer check3){
    this.check3 = check3;
  }

 public void setCharLevel(Integer charLevel) {
    this.charLevel = charLevel;
  }


 public void setChatLog(String chatLog) {
    this.chatLog = chatLog;
  }


public void setPurchasedBubbles(String purchasedBubbles){
	this.purchasedBubbles = purchasedBubbles;
}
public void setPurchasedCards(String purchasedCards){
  this.purchasedCards = purchasedCards;
}

public void setPermissions(String permissions){
	this.permissions = permissions;
}

public void setAchievements(String achievements){
	this.achievements = achievements;
}

public void setChallenges(String challenges){
	this.challenges = challenges;
}

public void setPurchasedBodies(String purchasedBodies){
	this.purchasedBodies = purchasedBodies;
}

public void setOutfits(String outfits){
	this.outfits = outfits;
}
public void setBankMoney(Integer bankMoney){
	this.bankMoney = bankMoney;
}
public String isBlog() {
    return isBlog;
  }

  public void setBlog(String isBlog) {
    this.isBlog = isBlog;
  }
public void setLastOnlineDay(int lastOnlineDay){
  this.lastOnlineDay = lastOnlineDay;
}
public Integer lastOnlineDay(){
  return lastOnlineDay;
}
public String blogURL() {
    return blogURL;
  }

  public void setBlogURL(String blogURL) {
    this.blogURL = blogURL;
  }
  public List<StuffItemLightTO> getClothes() {
    return clothes;
  }

  public void setClothes(List<StuffItemLightTO> clothes) {
    this.clothes = clothes;
  }

  public boolean isChatEnabledByParent() {
    return chatEnabledByParent;
  }

  public void setChatEnabledByParent(boolean chatEnabledByParent) {
    this.chatEnabledByParent = chatEnabledByParent;
  }

  public Integer getColor() {
    return color;
  }

  public void setColor(Integer color) {
    this.color = color;
  }

public StuffItemLightTO getPlayerCard() {
	return playerCard;
}

public void setPlayerCard(StuffItemLightTO playerCard) {
	this.playerCard = playerCard;
}

public Boolean getHasRobot() {
	return hasRobot;
}

public void setHasRobot(Boolean hasRobot) {
	this.hasRobot = hasRobot;
}

public String getTeamName() {
	return teamName;
}

public void setTeamName(String teamName) {
	this.teamName = teamName;
}

public String getCrewName() {
  return crewName;
}

public void setCrewName(String crewName) {
  this.crewName = crewName;
}

public int getTeamColor() {
	return teamColor;
}

public void setTeamColor(int teamColor) {
	this.teamColor = teamColor;
}

public int getCrewColor(){
  return crewColor;
}

public void setCrewColor(int crewColor){
  this.crewColor = crewColor;
}


}
