package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class AdminMessage extends ModelBase {

  private Long id;

  private String message;

  private User user;

  private boolean processed = false;

  public AdminMessage(String message, User user) {
    super();
    this.message = message;
    this.user = user;
  }

  public AdminMessage() {
    super();
    // TODO Auto-generated constructor stub
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  @ManyToOne
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public boolean isProcessed() {
    return processed;
  }

  public void setProcessed(boolean processed) {
    this.processed = processed;
  }

}
