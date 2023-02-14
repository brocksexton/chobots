package com.kavalok.db;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
public class UserExtraInfo extends ModelBase {

    private Date lastLoginDate;

    private Date lastLogoutDate;

    private Integer continuousDaysLoginCount;
	
    private Integer spins;

    //@Column(columnDefinition = "varchar(15) default 0")
    @Column(insertable = false, updatable = true)
    public String getLastAwardBugsDate() {
        return lastAwardBugsDate;

    }

    public void setLastAwardBugsDate(String lastAwardBugsDate) {
        this.lastAwardBugsDate = lastAwardBugsDate;
    }

    private String lastAwardBugsDate;

	@Column(insertable = false, updatable = true)
    public String getLastSpinDate() {
        return lastSpinDate;

    }

    public void setLastSpinDate(String lastSpinDate) {
        this.lastSpinDate = lastSpinDate;
    }

    private String lastSpinDate;
	
    private String lastIp;

    public Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public Date getLastLogoutDate() {
        return lastLogoutDate;
    }

    public void setLastLogoutDate(Date lastLogoutDate) {
        this.lastLogoutDate = lastLogoutDate;
    }

    @Column(columnDefinition = "int(10) default 0")
    public Integer getContinuousDaysLoginCount() {
        return continuousDaysLoginCount;
    }

    public void setContinuousDaysLoginCount(Integer continuousDaysLoginCount) {
        this.continuousDaysLoginCount = continuousDaysLoginCount;
    }

    @Column(columnDefinition = "int(10) default 0")
    public Integer getSpins() {
        return spins;
    }

    public void setSpins(Integer spins) {
        this.spins = spins;
    }
	
    public String getLastIp() {
        return lastIp;
    }

    public void setLastIp(String lastIp) {

        this.lastIp = lastIp;
    }

}
