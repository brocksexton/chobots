package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
public class UserServer {

  private Long id;

  private Server server;

  private Long serverId;

  private User user;

  private Long userId;

  public UserServer() {
    super();
  }

  public UserServer(User user, Server server) {
    super();
    setServer(server);
    setUser(user);
  }

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "serverId")
  public Server getServer() {
    return server;
  }

  public void setServer(Server server) {
    this.server = server;
  }

  @Column(insertable = false, updatable = false)
  public Long getServerId() {
    return serverId;
  }

  public void setServerId(Long serverId) {
    this.serverId = serverId;
  }

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "userId")
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  @Column(insertable = false, updatable = false)
  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

}
