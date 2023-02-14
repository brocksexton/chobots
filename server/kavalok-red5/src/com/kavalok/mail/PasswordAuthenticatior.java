package com.kavalok.mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class PasswordAuthenticatior extends Authenticator {
  private String user;
  private String password;
  
  
  public PasswordAuthenticatior(String user, String password) {
    super();
    this.user = user;
    this.password = password;
  }


  @Override
  protected PasswordAuthentication getPasswordAuthentication() {
    
    return new PasswordAuthentication(user, password);
  }

}
