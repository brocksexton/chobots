package com.kavalok.dto;

import com.kavalok.db.Server;

public class ServerTO {

  private int id;

  private String url;

  private String name;

  private int load;

  private boolean available;

  private boolean running;

  private int build;

  public ServerTO(Server server) {
    super();
    id = server.getId().intValue();
    url = server.getUrl();
    name = server.getName();
    available = server.isAvailable();
    running = server.isRunning();
    build = server.getBuild();
  }

  public ServerTO() {
    super();
    // TODO Auto-generated constructor stub
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getLoad() {
    return load;
  }

  public void setLoad(int load) {
    this.load = load;
  }

  public boolean isAvailable() {
    return available;
  }

  public void setAvailable(boolean available) {
    this.available = available;
  }

  public int getBuild() {
    return build;
  }

  public void setBuild(int build) {
    this.build = build;
  }


  public boolean isRunning() {
    return running;
  }

  public void setRunning(boolean running) {
    this.running = running;
  }

}
