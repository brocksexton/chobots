package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.Pet;

public class PetDAO extends DAO<Pet> {

	public PetDAO(Session session) {
		super(session);
	}
	
	public Pet findByChar(GameChar gameChar) {
		return findByParameter("gameChar", gameChar);
	}
}
