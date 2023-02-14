package com.kavalok.dto.statistics;

public class MembersAgeTO {
	
	private int periodMonth;
	private int userAge;
	private int userCount;
	
	public MembersAgeTO(Object[] objects) {
		this.userCount = ((Long)objects[0]).intValue();
		this.periodMonth = (Byte)objects[1];
		this.userAge = ((Integer)objects[2]).intValue();
	}
	public MembersAgeTO(int periodMonth, int userAge, int userCount) {
		super();
		this.periodMonth = periodMonth;
		this.userAge = userAge;
		this.userCount = userCount;
	}
	public int getPeriodMonth() {
		return periodMonth;
	}
	public void setPeriodMonth(int periodMonth) {
		this.periodMonth = periodMonth;
	}
	public int getUserAge() {
		return userAge;
	}
	public void setUserAge(int userAge) {
		this.userAge = userAge;
	}
	public int getUserCount() {
		return userCount;
	}
	public void setUserCount(int userCount) {
		this.userCount = userCount;
	}
}
