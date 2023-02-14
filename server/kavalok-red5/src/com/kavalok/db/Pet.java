package com.kavalok.db;

import javax.persistence.Column;
import java.util.Date;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class Pet extends ModelBase {

	private GameChar gameChar;
	
	private PetItem body;
	private int bodyColor;
	
	private PetItem face;
	private int faceColor;
	
	private PetItem top;
	private int topColor;
	
	private PetItem side;
	private int sideColor;

	private PetItem bottom;
	private int bottomColor;
	
	private String name;
	private int health;
	private int food;
	private int loyality;
	private boolean enabled;
	private boolean atHome;
	private boolean sit;
	private Date created;
	
	@Column(columnDefinition = "boolean default true")
	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	@NotNull
	@ManyToOne
	public PetItem getBody() {
		return body;
	}

	public void setBody(PetItem body) {
		this.body = body;
	}

	@NotNull
	@ManyToOne
	public PetItem getFace() {
		return face;
	}

	public void setFace(PetItem face) {
		this.face = face;
	}

	public int getBodyColor() {
		return bodyColor;
	}

	public void setBodyColor(int bodyColor) {
		this.bodyColor = bodyColor;
	}

	public int getFaceColor() {
		return faceColor;
	}

	public void setFaceColor(int faceColor) {
		this.faceColor = faceColor;
	}

	@NotNull
	@ManyToOne
	public PetItem getTop() {
		return top;
	}

	public void setTop(PetItem top) {
		this.top = top;
	}

	public int getTopColor() {
		return topColor;
	}

	public void setTopColor(int topColor) {
		this.topColor = topColor;
	}

	@NotNull
	@ManyToOne
	public PetItem getSide() {
		return side;
	}

	public void setSide(PetItem side) {
		this.side = side;
	}

	public int getSideColor() {
		return sideColor;
	}

	public void setSideColor(int sideColor) {
		this.sideColor = sideColor;
	}

	@NotNull
	@ManyToOne
	public PetItem getBottom() {
		return bottom;
	}

	public void setBottom(PetItem bottom) {
		this.bottom = bottom;
	}

	public int getBottomColor() {
		return bottomColor;
	}

	public void setBottomColor(int bottomColor) {
		this.bottomColor = bottomColor;
	}

	@NotNull
	@ManyToOne(fetch=FetchType.LAZY)
	public GameChar getGameChar() {
		return gameChar;
	}

	public void setGameChar(GameChar gameChar) {
		this.gameChar = gameChar;
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

	@Transient
	public int getPrice() {
		return body.getPrice()
			+ face.getPrice()
			+ top.getPrice()
			+ side.getPrice()
			+ bottom.getPrice();
	}

	@NotNull
	@Column(columnDefinition = "varchar(15)")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Column(columnDefinition = "boolean default true")
	public Boolean getAtHome() {
		return atHome;
	}

	public void setAtHome(Boolean atHome) {
		this.atHome = atHome;
	}

		@Column(columnDefinition = "boolean default false")
	public Boolean getSit() {
		return sit;
	}

	public void setSit(Boolean sit) {
		this.sit = sit;
	}

}
