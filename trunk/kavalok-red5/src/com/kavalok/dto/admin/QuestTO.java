package com.kavalok.dto.admin;

import com.kavalok.db.Quest;
import com.kavalok.db.Server;

public class QuestTO {

	private Long id;
	private String name;
	private Boolean enabled;
	private Long serverId;
	
	public QuestTO() {
	}
	
	public QuestTO(Quest quest) {
		id = quest.getId();
		name = quest.getName();
		enabled = quest.isEnabled();
		
		Server server = quest.getServer();
		
		if (server != null)
			serverId = quest.getServer().getId();
		else
			serverId = -1L;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getEnabled() {
		return enabled;
	}

	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}

	public Long getServerId() {
		return serverId;
	}

	public void setServerId(Long serverId) {
		this.serverId = serverId;
	}

}
