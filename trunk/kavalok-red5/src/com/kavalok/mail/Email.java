package com.kavalok.mail;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class Email {
  @Element
  public String title;

  @Element
  public String content;

  public Email(String title, String content) {
    super();
    this.title = title;
    this.content = content;
  }

  public Email() {
    super();
    // TODO Auto-generated constructor stub
  }

}
