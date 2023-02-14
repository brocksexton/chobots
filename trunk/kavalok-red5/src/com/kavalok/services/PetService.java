package com.kavalok.services;

import java.util.List;

import com.kavalok.dao.GameCharDAO;
import com.kavalok.dao.PetDAO;
import com.kavalok.dao.PetItemDAO;
import com.kavalok.dao.StuffItemDAO;
import com.kavalok.dao.StuffTypeDAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.Pet;
import com.kavalok.db.PetItem;
import com.kavalok.db.StuffItem;
import com.kavalok.db.StuffType;
import com.kavalok.dto.pet.PetTO;
import com.kavalok.messages.MessageCheck;
import com.kavalok.messages.MessageCheckResult;
import com.kavalok.messages.MessageSafety;
import com.kavalok.services.common.DataServiceBase;
import com.kavalok.user.UserManager;

public class PetService extends DataServiceBase {
	
	public List<PetItem> getPetItems() {
		return new PetItemDAO(getSession()).findAll();
	}
	
	private GameChar getGameChar() {
		return UserManager.getInstance().getCurrentUser().getChar(
				getSession());
	}
	
	public void saveParams(Integer health, Integer food, Integer loyality, Boolean atHome, Boolean sit) {
		GameChar gameChar = getGameChar();
		PetDAO petDAO = new PetDAO(getSession());
		Pet pet = petDAO.findByChar(gameChar);
		
		pet.setHealth(health);
		pet.setFood(food);
		pet.setLoyality(loyality);
		pet.setAtHome(atHome);
		pet.setSit(sit);
		
		petDAO.makePersistent(pet);
	}
	
	public void disposePet() {
		GameChar gameChar = getGameChar();
		PetDAO petDAO = new PetDAO(getSession());
		Pet pet = petDAO.findByChar(gameChar);
		pet.setEnabled(false);
		petDAO.makePersistent(pet);
	}
	
	private void getDefaultItems(GameChar gameChar) {
		StuffTypeDAO typeDAO = new StuffTypeDAO(getSession());
		StuffItemDAO itemDAO = new StuffItemDAO(getSession());
		
		StuffType restType = typeDAO.findByFileName("podushka");
		if (!gameChar.hasItem(restType)) {
			StuffItem restItem = new StuffItem(restType);
			restItem.setGameChar(gameChar);
			itemDAO.makePersistent(restItem);
		}
		
		StuffType playType = typeDAO.findByFileName("gameBall");
		if (!gameChar.hasItem(playType)) {
			StuffItem playItem = new StuffItem(playType);
			playItem.setGameChar(gameChar);
			itemDAO.makePersistent(playItem);
		}
	}
	
	public PetTO savePet(PetTO petTO) {
		GameChar gameChar = UserManager.getInstance().getCurrentUser().getChar(
				getSession());

		PetItemDAO petItemDAO = new PetItemDAO(getSession());
		PetDAO petDAO = new PetDAO(getSession());
		Pet pet = petDAO.findByChar(gameChar);
		
		MessageCheckResult result = new MessageCheck(getSession()).check(petTO.getName());
		if (result.getSafety() != MessageSafety.SAFE)
			return null;

		if (pet == null) {
			pet = new Pet();
			pet.setGameChar(gameChar);
		}
		
		getDefaultItems(gameChar);
		
		pet.setEnabled(true);
		pet.setName(petTO.getName());
		pet.setAtHome(petTO.getAtHome());
		pet.setSit(petTO.getSit());

		pet.setBody(petItemDAO.findByName(petTO.getBody()));
		pet.setFace(petItemDAO.findByName(petTO.getFace()));
		pet.setTop(petItemDAO.findByName(petTO.getTop()));
		pet.setSide(petItemDAO.findByName(petTO.getSide()));
		pet.setBottom(petItemDAO.findByName(petTO.getBottom()));

		pet.setBodyColor(petTO.getBodyColor());
		pet.setFaceColor(petTO.getFaceColor());
		pet.setTopColor(petTO.getTopColor());
		pet.setSideColor(petTO.getSideColor());
		pet.setBottomColor(petTO.getBottomColor());
		
		pet.setHealth(petTO.getHealth());
		pet.setFood(petTO.getFood());
		pet.setLoyality(petTO.getLoyality());
		
		int price = pet.getPrice();
		
		if (gameChar.getMoney() < price) {
			return null;
		} else {
			petDAO.makePersistent(pet);
			gameChar.setMoney(gameChar.getMoney() - price);
			new GameCharDAO(getSession()).makePersistent(gameChar);
		}
		
		return new PetTO(pet);
	}

}
