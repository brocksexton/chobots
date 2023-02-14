package com.kavalok.dto.infoPanel;

import java.util.Date;

import com.kavalok.db.InfoPanel;

public class InfoPanelAdminTO {
	private Long id;
	private Date created;
	private String caption;
	private Boolean enabled;
	private String data;
	
	public InfoPanelAdminTO() {
		super();
	}
	
	public InfoPanelAdminTO(InfoPanel infoPanel) {
		super();
		
		this.id = infoPanel.getId();
		this.caption = infoPanel.getCaption();
		this.data = infoPanel.getData();
		this.enabled = infoPanel.getEnabled();
		this.created = infoPanel.getCreated();
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCaption() {
		return caption;
	}
	public void setCaption(String caption) {
		this.caption = caption;
	}
	public Boolean getEnabled() {
		return enabled;
	}
	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}

}
