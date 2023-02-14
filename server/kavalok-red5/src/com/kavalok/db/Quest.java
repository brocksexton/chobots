package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class Quest extends ModelBase {

	private String name;
	private boolean enabled;
	private Server server;

	@NotNull
	@Column(unique = true)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(columnDefinition = "boolean default true")
	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	@ManyToOne(fetch=FetchType.LAZY)
	public Server getServer() {
		return server;
	}

	public void setServer(Server server) {
		this.server = server;
	}

}
