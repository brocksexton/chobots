package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

@Entity
public class News extends ModelBase {
	private Long id;

	private String dates;

	private String info;
	
	private String image;
	
	private String charName;

	private Integer num;

	private Boolean show;
	
	@Id
	@GeneratedValue
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@NotNull
	@Column(unique = true)
	public String getDates() {
		return dates;
	}

	public void setDates(String dates) {
		this.dates = dates;
	}

	@NotNull
	@Column(unique = true)
	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	@NotNull
	@Column(unique = true)
	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

		@NotNull
	@Column(unique = true)
	public String getCharName() {
		return charName;
	}

	public void setCharName(String charName) {
		this.charName = charName;
	}


		@NotNull
	@Column(unique = true)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}


	@NotNull
	@Column(columnDefinition = "boolean default false")
	public boolean isShow() {
		return show;
	}

	public void setShow(boolean show) {
		this.show = show;
	}
	public News() {
		super();
	}
/*	@Transient
	public String getIp() {
		return getUrl().split("/")[0];
	}

	@Transient
	public String getContextPath() {
		return getUrl().split("/")[1];
	}*/

/*
  @NotNull
  @Column(columnDefinition = "boolean default false")
  public boolean isRunning() {
    return running;
  }

  public void setRunning(boolean running) {
    this.running = running;
  }*/
}
