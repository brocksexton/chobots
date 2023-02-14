package com.kavalok.dao;

import java.util.List;

import com.kavalok.db.StuffItem;
import com.kavalok.db.StuffType;

import junit.framework.TestCase;

public class StuffDAOTest extends TestCase {

	public void testCreateNewItem() {
		StuffType type = new StuffDAO().getByName("Triangle");
		StuffItem item = new StuffDAO().createNewItem(type);
		assertEquals(item.getType().getName(), type.getName());
	}

	public void testGetStuffTypes() {
		List<StuffType> types = new StuffDAO().getStuffTypes();
		StuffType type = types.get(0);
		assertEquals("Triangle", type.getName());
	}
}
