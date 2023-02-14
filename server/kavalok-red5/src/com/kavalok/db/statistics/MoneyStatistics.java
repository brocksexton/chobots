package com.kavalok.db.statistics;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import org.hibernate.validator.NotNull;

import com.kavalok.dao.QueriesNames;
import com.kavalok.db.User;

@Entity
@NamedQueries( {
    
    @NamedQuery(name = QueriesNames.MONEY_STATISTICS_SELECT_COUNT, query =
    	"select count(*) from MoneyStatistics as item "
        + "where item.date < :maxDate and item.date > :minDate " + "group by item.user"),

	/*@NamedQuery(name = QueriesNames.MONEY_STATISTICS_SELECT_COUNT, query = 
		"select count(*) from (select from MoneyStatistics as item "
        + "where item.date < :maxDate and item.date > :minDate " + "group by item.user)"),*/
        
    @NamedQuery(name = QueriesNames.MONEY_STATISTICS_SELECT_FOR_USERS, query = "select item.user, sum(item.money) "

    + "from MoneyStatistics as item " + "where item.date < :maxDate and item.date > :minDate " + "group by item.user "
        + "order by sum(item.money) desc") })
public class MoneyStatistics {

  private long id;

  private User user;

  private Long money;

  private Date date;

  private String reason;

  public MoneyStatistics() {
    super();
    // TODO Auto-generated constructor stub
  }

  public MoneyStatistics(User user, Long money, Date date, String reason) {
    super();
    this.user = user;
    this.money = money;
    this.date = date;
    this.reason = reason;
  }

  public MoneyStatistics(User user, Long money, Date date) {
    this(user, money, date, "");
  }

  @Id
  @GeneratedValue
  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  @NotNull
  @ManyToOne
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  @NotNull
  public Long getMoney() {
    return money;
  }

  public void setMoney(Long money) {
    this.money = money;
  }

  @NotNull
  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

}
