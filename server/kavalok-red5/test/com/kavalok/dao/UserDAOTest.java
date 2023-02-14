package com.kavalok.dao;

import junit.framework.TestCase;

import com.kavalok.db.User;

public class UserDAOTest extends TestCase {

	public void testCreate() {
		UserDAO userDAO = new UserDAO();
		userDAO.createUser("test@aaa.aaa", "testPass");
		User user = userDAO.getUser("test@aaa.aaa");
		assertEquals("testPass", user.getPassword());
	}
}
