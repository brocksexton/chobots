package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class UserReport extends ModelBase {
  private Long id;

  private User reporter;

  private User user;

  private String text;

  private Boolean processed = false;

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  @ManyToOne(fetch=FetchType.LAZY)
  @NotNull
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  @Column(columnDefinition = "text not null")
  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }

  @ManyToOne(fetch=FetchType.LAZY)
  @NotNull
  public User getReporter() {
    return reporter;
  }

  public void setReporter(User reporter) {
    this.reporter = reporter;
  }

  @Column(columnDefinition = "boolean default false")
  public Boolean getProcessed() {
    return processed;
  }

  public void setProcessed(Boolean processed) {
    this.processed = processed;
  }

}
