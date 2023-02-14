package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class Anim extends ModelBase {
	private Long id;

	private String name;

	private String link;
	
	private boolean enabled;

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
	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	@NotNull
	@Column(unique = true)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

/*	@Transient
	public String getIp() {
		return getUrl().split("/")[0];
	}

	@Transient
	public String getContextPath() {
		return getUrl().split("/")[1];
	}*/

	public Anim() {
		super();
	}
/*
  @NotNull
  @Column(columnDefinition = "boolean default false")
  public boolean isRunning() {
    return running;
  }

  public void setRunning(boolean running) {
    this.running = running;
  }*/
}
