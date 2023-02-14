package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.PetItem;

public class PetItemDAO extends DAO<PetItem> {

	public PetItemDAO(Session session) {
		super(session);
	}
	
	public PetItem findByName(String name) {
		return findByParameter("name", name);
	}
	
}
