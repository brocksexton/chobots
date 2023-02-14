package com.kavalok.dto.pet;

import com.kavalok.db.Pet;
import java.util.Date;
public class PetTO {
	
	private Long id;
	
	private String body;
	private int bodyColor;
	
	private String face;
	private int faceColor;
	
	private String top;
	private int topColor;
	
	private String side;
	private int sideColor;

	private String bottom;
	private int bottomColor;
	
	private String name;
	private int health;
	private int food;
	private int loyality;
	private Long lAge;
	private int age;
	private boolean atHome;
		private boolean sit;
	
	public PetTO() {
		super();
	}
	
	public PetTO(Pet pet) {
		

		body = pet.getBody().getName();
		bodyColor = pet.getBodyColor();
		face = pet.getFace().getName();
		faceColor = pet.getFaceColor();
		top = pet.getTop().getName();
		topColor = pet.getTopColor();
		side = pet.getSide().getName();
		sideColor = pet.getSideColor();
		bottom = pet.getBottom().getName();
		bottomColor = pet.getBottomColor();
		atHome = pet.getAtHome();
		sit = pet.getSit();
		
		health = pet.getHealth();
		food = pet.getFood();
		loyality = pet.getLoyality();
		name = pet.getName();
		id = pet.getId();
		lAge = (new Date().getTime() - pet.getCreated().getTime()) / 1000 / 60 / 60 / 24;
		age = lAge.intValue();
		
	}

	public String getBody() {
		return body;
	}

 
	public void setBody(String body) {
		this.body = body;
	}

	public int getBodyColor() {
		return bodyColor;
	}

	public void setBodyColor(int bodyColor) {
		this.bodyColor = bodyColor;
	}

	public String getFace() {
		return face;
	}

	public void setFace(String face) {
		this.face = face;
	}

	public int getFaceColor() {
		return faceColor;
	}

	public void setFaceColor(int faceColor) {
		this.faceColor = faceColor;
	}

	public String getTop() {
		return top;
	}

	public void setTop(String top) {
		this.top = top;
	}

	public int getTopColor() {
		return topColor;
	}

	public void setTopColor(int topColor) {
		this.topColor = topColor;
	}

		public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getSide() {
		return side;
	}

	public void setSide(String side) {
		this.side = side;
	}

	public int getSideColor() {
		return sideColor;
	}

	public void setSideColor(int sideColor) {
		this.sideColor = sideColor;
	}

	public String getBottom() {
		return bottom;
	}

	public void setBottom(String bottom) {
		this.bottom = bottom;
	}

	public int getBottomColor() {
		return bottomColor;
	}

	public void setBottomColor(int bottomColor) {
		this.bottomColor = bottomColor;
	}

	public int getHealth() {
		return health;
	}

	public void setHealth(int health) {
		this.health = health;
	}

	public int getFood() {
		return food;
	}

	public void setFood(int food) {
		this.food = food;
	}

	public int getLoyality() {
		return loyality;
	}

	public void setLoyality(int loyality) {
		this.loyality = loyality;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public boolean getAtHome() {
		return atHome;
	}

	public void setAtHome(boolean atHome) {
		this.atHome = atHome;
	}

	public boolean getSit() {
		return sit;
	}

	public void setSit(boolean sit) {
		this.sit = sit;
	}

}
