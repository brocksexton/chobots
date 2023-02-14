package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
public class EmailExtraInfo extends ModelBase {

  private String email;

  private String lastRemindPasswordDate;

  private Integer remindPasswordCount;

  public String getLastRemindPasswordDate() {
    return lastRemindPasswordDate;
  }

  public void setLastRemindPasswordDate(String lastRemindPasswordDate) {
    this.lastRemindPasswordDate = lastRemindPasswordDate;
  }

  public Integer getRemindPasswordCount() {
    return remindPasswordCount;
  }

  public void setRemindPasswordCount(Integer remindPasswordCount) {
    this.remindPasswordCount = remindPasswordCount;
  }

  @Column(unique = true)
  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

}
