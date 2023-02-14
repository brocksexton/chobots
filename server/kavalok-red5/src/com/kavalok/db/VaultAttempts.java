package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;

import org.hibernate.validator.NotNull;

import com.kavalok.dao.QueriesNames;

@Entity
public class VaultAttempts extends ModelBase {

  private String login;
  private Long user_id;
  private Integer entries;
  private String created;

  public VaultAttempts() {
    super();
  }

  public VaultAttempts(String login, Long userId, Integer entries) {
    super();
    this.login = login;
    this.user_id = userId;
    this.entries = entries;
  }

  public Integer getEntries(){
    return entries;
  }

  public void setEntries(Integer entries){
    this.entries = entries;
  }

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
