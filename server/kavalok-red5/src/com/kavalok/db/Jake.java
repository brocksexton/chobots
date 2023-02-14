package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import com.kavalok.permissions.AccessPartner;

@Entity
public class Jake extends LoginModelBase {
	Long id;

	StuffType stuff;

  String portalUrl;

  @Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@SuppressWarnings("unchecked")
	@Override
	@Transient
	public Class getAccessType() {
		return AccessPartner.class;
	}
	
	@ManyToOne
	public StuffType getStuff() {
		return stuff;
	}

	public void setStuff(StuffType stuff) {
		this.stuff = stuff;
	}

  public String getPortalUrl() {
    return portalUrl;
  }

  public void setPortalUrl(String portalUrl) {
    this.portalUrl = portalUrl;
  }


}
