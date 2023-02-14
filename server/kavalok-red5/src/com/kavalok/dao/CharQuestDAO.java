package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.CharQuest;
import com.kavalok.db.GameChar;

public class CharQuestDAO extends DAO<CharQuest> {

	public CharQuestDAO(Session session) {
		super(session);
	}
	
	public List<CharQuest> findByChar(GameChar gameChar) {
		return findAllByParameter("gameChar", gameChar);
	}
}
