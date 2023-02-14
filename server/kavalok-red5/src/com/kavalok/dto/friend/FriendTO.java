package com.kavalok.dto.friend;

public class FriendTO {

  private String login;

  private Integer userId;

  private String server;

  public FriendTO() {
    super();
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

  public String getServer() {
    return server;
  }

  public void setServer(String server) {
    this.server = server;
  }

  public Integer getUserId() {
    return userId;
  }

  public void setUserId(Integer userId) {
    this.userId = userId;
  }

  private Object fixNull(Object value) {
    if (value == null)
      return "";
    return value;
  }

  @Override
  public String toString() {
    return fixNull(getUserId()).toString();
  }

  public String toStringPresentation() {
    return fixNull(getLogin()) + "|" + fixNull(getUserId()) + "|" + fixNull(getServer());
  }

}
