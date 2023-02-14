package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

@MappedSuperclass
public class LoginModelBase extends ModelBase {

  private String login;

  private String password;

  @NotNull
  @Column(unique = true)
  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

  @NotNull
  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  @SuppressWarnings("unchecked")
  @Transient
  public Class getAccessType() {
    throw new NotImplementedException();
  }

}
