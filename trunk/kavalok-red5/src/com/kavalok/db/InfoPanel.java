package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class InfoPanel extends ModelBase {

	private String caption;
	private Boolean enabled;
	private String data;

	@NotNull
	@Column(unique = true)
	public String getCaption() {
		return caption;
	}

	@NotNull
	public void setCaption(String caption) {
		this.caption = caption;
	}

	@Column(columnDefinition = "bit(1) not null default false")
	public Boolean getEnabled() {
		return enabled;
	}

	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}

	@Column(columnDefinition = "TEXT CHARACTER SET utf8 NOT NULL")
	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}


}
