package com.kavalok.dto.login;

import com.kavalok.db.User;

public class ActivationTO {

  private String email;
  private Boolean parent;
  
  
  public ActivationTO() {
    super();
  }

  public ActivationTO(User user) {
    super();
    email = user.getEmail();
    parent = user.isParent();
  }
  
  public String getEmail() {
    return email;
  }
  public void setEmail(String email) {
    this.email = email;
  }
  public Boolean getParent() {
    return parent;
  }
  public void setParent(Boolean parent) {
    this.parent = parent;
  }
  
  
  
}
