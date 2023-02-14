package com.kavalok.dao;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.UserDance;

public class UserDanceDAO extends DAO<UserDance> {

	public UserDanceDAO(Session session) {
		super(session);
	}

}
