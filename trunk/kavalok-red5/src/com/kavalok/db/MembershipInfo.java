package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
public class MembershipInfo extends ModelBase {

  private Boolean finishingNotificationShowed = false;

  private Boolean finishedNotificationShowed = false;

  @Column(columnDefinition = "boolean default false")
  public Boolean getFinishingNotificationShowed() {
    return finishingNotificationShowed;
  }

  public void setFinishingNotificationShowed(Boolean finishingNotificationShowed) {
    this.finishingNotificationShowed = finishingNotificationShowed;
  }

  @Column(columnDefinition = "boolean default false")
  public Boolean getFinishedNotificationShowed() {
    return finishedNotificationShowed;
  }

  public void setFinishedNotificationShowed(Boolean finishedNotificationShowed) {
    this.finishedNotificationShowed = finishedNotificationShowed;
  }

}
