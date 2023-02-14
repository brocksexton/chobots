package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import org.hibernate.validator.NotNull;

@Entity
public class CharQuest extends ModelBase {

	private GameChar gameChar;
	private Quest quest;
	private String state;
	
	@NotNull
	@ManyToOne(fetch=FetchType.LAZY)
	public GameChar getGameChar() {
		return gameChar;
	}

	public void setGameChar(GameChar gameChar) {
		this.gameChar = gameChar;
	}

	@NotNull
	@ManyToOne(fetch=FetchType.LAZY)
	public Quest getQuest() {
		return quest;
	}

	public void setQuest(Quest quest) {
		this.quest = quest;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

}
