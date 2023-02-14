package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.validator.NotNull;
import javax.persistence.Column;

import org.hibernate.annotations.Type;

@Entity
public class BestFriends extends ModelBase {

  private Long userId;

  private Long id;

  private Long friendId;

  private Boolean enabled;

  public BestFriends() {
    super();
  }


  public BestFriends(Long userId, Long friendId, Boolean enabled) {
    super();
    this.userId = userId; //UserID = victim that got BFF'd
    this.friendId = friendId; //FriendID = user that made the other user BFF. he will receive notifications!
    this.enabled = enabled;
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public Long getFriendId(){
    return friendId;
  }

  public void setFriendId(Long friendId)
  {
    this.friendId = friendId;
  }

  @NotNull
  @Column(columnDefinition = "boolean default true")
  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }

}
