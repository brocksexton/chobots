package com.kavalok.dto;

import com.kavalok.db.User;

public class ModTO {

 // private int id;

  //private String link;

  private String name;

  //private int load;

  //private boolean enabled;

 // private boolean running;

  public ModTO(User user) {
    super();
   // id = user.getId().intValue();
   // link = anim.getLink();
    name = user.getLogin();
    setName(user.getLogin());
   // enabled = anim.isEnabled();
  }

  public ModTO() {
    super();
    // TODO Auto-generated constructor stub
  }
/*
  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getLink() {
    return link;
  }

  public void setLink(String link) {
    this.link = link;
  }
*/
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

/*
  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }*/


}
