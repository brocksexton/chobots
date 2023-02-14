package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;

import com.kavalok.dao.QueriesNames;
import com.kavalok.db.ModelBase;
import com.kavalok.db.Transaction;
import com.kavalok.db.User;

@Entity
@NamedQuery(name=QueriesNames.STATISTICS_SELECT_MEMBERS_AGE, 
		query="select count(*), periodMonths,  floor((UNIX_TIMESTAMP(created) - UNIX_TIMESTAMP(user.created))/:period) as days " +
				"	from MembershipHistory where created between :from and :to and transaction is not null " +
				"	group by periodMonths, floor((UNIX_TIMESTAMP(created) - UNIX_TIMESTAMP(user.created))/:period)" +
				"	order by floor((UNIX_TIMESTAMP(created) - UNIX_TIMESTAMP(user.created))/:period)")
public class MembershipHistory extends ModelBase {

  private User user;

  private Transaction transaction;

  private String reason;

  private Date endDate;

  private Byte periodDays;

  private Byte periodMonths;

  @ManyToOne(fetch = FetchType.LAZY)
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  public Byte getPeriodDays() {
    return periodDays;
  }

  public void setPeriodDays(Byte periodDays) {
    this.periodDays = periodDays;
  }

  public Byte getPeriodMonths() {
    return periodMonths;
  }

  public void setPeriodMonths(Byte periodMonths) {
    this.periodMonths = periodMonths;
  }

  @ManyToOne(fetch = FetchType.LAZY)
  public Transaction getTransaction() {
    return transaction;
  }

  public void setTransaction(Transaction transaction) {
    this.transaction = transaction;
  }

}
