package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class Server extends ModelBase {
	private Long id;

	private String url;

	private String name;

	private boolean available;

	private int build;

  private boolean running;

	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@NotNull
	@Column(unique = true)
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@NotNull
	@Column(unique = true)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(nullable = false, columnDefinition = "int(6) default 1")
public Integer getBuild(){
	return build;
}
  public void setBuild(int build) {
	this.build = build;
}

	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isAvailable() {
		return available;
	}

	public void setAvailable(boolean available) {
		this.available = available;
	}

	@Transient
	public String getIp() {
		return getUrl().split("/")[0];
	}

	@Transient
	public String getContextPath() {
		return getUrl().split("/")[1];
	}

	public Server() {
		super();
	}

  @NotNull
  @Column(columnDefinition = "boolean default false")
  public boolean isRunning() {
    return running;
  }

  public void setRunning(boolean running) {
    this.running = running;
  }
}
