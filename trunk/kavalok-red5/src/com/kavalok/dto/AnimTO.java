package com.kavalok.dto;

import com.kavalok.db.Anim;

public class AnimTO {

  private int id;

  private String link;

  private String name;

  //private int load;

  private boolean enabled;

 // private boolean running;

  public AnimTO(Anim anim) {
    super();
    id = anim.getId().intValue();
    link = anim.getLink();
    name = anim.getName();
    enabled = anim.isEnabled();
  }

  public AnimTO() {
    super();
    // TODO Auto-generated constructor stub
  }

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

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }


  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }


}
