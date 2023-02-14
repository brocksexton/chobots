package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;

import org.hibernate.validator.NotNull;

import com.kavalok.dao.QueriesNames;

@Entity
public class Stickers extends ModelBase {

  private String login;

  private Long user_id;

  private int stickerId;

  private Boolean valid;

  public Stickers() {
    super();
  }

  public Stickers(String login, Long userId, int stickerId, Boolean valid) {
    super();
    this.login = login;
    this.user_id = userId;
    this.stickerId = stickerId;
    this.valid = valid;
  }

  public int getStickerId() {
    return stickerId;
  }

  public void setStickerId(int stickerId) {
    this.stickerId = stickerId;
  }

  public Boolean getValid(){
    return valid;
  }

  public void setValid(Boolean valid){
    this.valid = valid;
  }

  @Column(insertable = false, updatable = false)
  public Long getUser_id() {
    return user_id;
  }

  public void setUser_id(Long user_id) {
    this.user_id = user_id;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

}
