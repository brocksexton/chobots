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
    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_SELECT_FOR_ALL, query = "select sum(UNIX_TIMESTAMP(item.logoutDate) - UNIX_TIMESTAMP(item.loginDate)), count(*) "
        + "from LoginStatistics as item " + "where item.logoutDate < :maxDate and item.loginDate > :minDate "),
    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_SELECT_FOR_USERS, query = "select item.user, sum(UNIX_TIMESTAMP(item.logoutDate) - UNIX_TIMESTAMP(item.loginDate)), count(*) "
        + "from LoginStatistics as item "
        + "where item.logoutDate < :maxDate and item.loginDate > :minDate "
        + "group by item.user " + "order by sum(UNIX_TIMESTAMP(item.logoutDate) - UNIX_TIMESTAMP(item.loginDate)) desc"),
    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_FOR_USERS, query = "select item.user "
        + "from LoginStatistics as item " + "where item.logoutDate < :maxDate and item.loginDate > :minDate "
        + "group by item.user "),
    
//    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_COUNT_FOR_USERS, query =
//    		"select count(*) from LoginStatistics as item "
//    		+ "where item.logoutDate < :maxDate and item.loginDate > :minDate "
//    		+ "group by item.user"),
    
//    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_COUNT_FOR_USERS, query = "select count(*) from("
//          + "select from LoginStatistics as item " + "where item.logoutDate < :maxDate and item.loginDate > :minDate "
//          + "group by item.user )"),
          
    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_SESSION_TIME, query = "select sum(UNIX_TIMESTAMP(item.logoutDate) - UNIX_TIMESTAMP(item.loginDate)) "
        + "from LoginStatistics as item "
        + "where item.user = :user and item.logoutDate <= :maxDate and item.loginDate >= :minDate "
        + "group by item.user"),
    @NamedQuery(name = QueriesNames.LOGIN_STATISTICS_AVERAGE_SESSION_TIME, query = "select avg(UNIX_TIMESTAMP(item.logoutDate) - UNIX_TIMESTAMP(item.loginDate))"
      + "from LoginStatistics as item "
      + "where item.logoutDate <= :maxDate and item.loginDate >= :minDate") })
public class LoginStatistics {

  private Long id;

  private User user;

  private Date loginDate;

  private Date logoutDate;
  private String ip;
  private String login;

  public LoginStatistics() {
    super();
    // TODO Auto-generated constructor stub
  }

  public LoginStatistics(User user, Date loginDate, Date logoutDate, String ip, String login) {
    super();
    this.user = user;
    this.loginDate = loginDate;
    this.logoutDate = logoutDate;
    this.ip = ip;
    this.login = login;
  }

  @GeneratedValue
  @Id
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
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
  public Date getLoginDate() {
    return loginDate;
  }

  public void setLoginDate(Date loginDate) {
    this.loginDate = loginDate;
  }

  @NotNull
  public Date getLogoutDate() {
    return logoutDate;
  }

  public void setLogoutDate(Date logoutDate) {
    this.logoutDate = logoutDate;
  }

  public String getIp(){
    return ip;
  }
  public void setIp(String ip){
    this.ip = ip;
  }

    public String getLogin(){
    return login;
  }
  public void setLogin(String login){
    this.login = login;
  }

}
