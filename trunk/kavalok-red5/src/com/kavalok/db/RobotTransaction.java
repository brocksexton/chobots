package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.kavalok.dao.QueriesNames;



@Entity
@NamedQueries( {

    @NamedQuery(name = QueriesNames.ROBOT_TRANSACTION_STATISTICS_SELECT_PROCESSED, query = "select t, count(*) from RobotTransaction as t "
        + " where t.state=2 and t.created < :maxDate and t.created >= :minDate "
        + " group by t.robotSKU order by t.robotSKU.name asc "),

    @NamedQuery(name = QueriesNames.ROBOT_TRANSACTION_STATISTICS_SELECT_PROCESSED_PARTNER, query = "select t, count(*) "
        + " from RobotTransaction t left join fetch t.user u left join fetch u.marketingInfo m "
        + " where t.state=2 and t.created < :maxDate and t.created >= :minDate and m.partner.id = :partnerId "
        + " group by t.robotSKU order by t.robotSKU.name asc ")

})
 
public class RobotTransaction extends ModelBase {
  private User user;

  private RobotSKU robotSKU;

  private String billingRequestParams;

  private String source;

  private byte state = 0;

  public RobotTransaction() {
    super();
  }

  public byte getState() {
    return state;
  }

  public void setState(byte state) {
    this.state = state;
  }

  @Column(columnDefinition = "longtext")
  public String getBillingRequestParams() {
    return billingRequestParams;
  }

  public void setBillingRequestParams(String billingRequestParams) {
    this.billingRequestParams = billingRequestParams;
  }

  @ManyToOne(fetch = FetchType.LAZY)
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  @Column(columnDefinition = "varchar(50)")
  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  @ManyToOne(fetch = FetchType.LAZY)
  public RobotSKU getRobotSKU() {
    return robotSKU;
  }

  public void setRobotSKU(RobotSKU robotSKU) {
    this.robotSKU = robotSKU;
  }

}
