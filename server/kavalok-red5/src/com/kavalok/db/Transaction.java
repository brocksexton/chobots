package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.kavalok.dao.QueriesNames;

@Entity
@NamedQueries( {

    @NamedQuery(name = QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED, query = "select t, count(*) from Transaction as t "
        + " where t.state=2 and t.created < :maxDate and t.created >= :minDate and t.type=-1 "
        + " group by t.sku order by successMessage asc "),

    @NamedQuery(name = QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED_PARTNER, query = "select t, count(*) "
        + " from Transaction t left join fetch t.user u left join fetch u.marketingInfo m "
        + " where t.state=2 and t.created < :maxDate and t.created >= :minDate and m.partner.id = :partnerId and t.type=-1 "
        + " group by t.sku order by t.successMessage asc "),

    @NamedQuery(name = QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED_OLD, query = "select t, count(*) from Transaction as t "
        + " where t.state=2 and t.created < :maxDate and t.created >= :minDate and t.type<>-1 "
        + " group by t.type order by successMessage asc "),

    @NamedQuery(name = QueriesNames.TRANSACTION_STATISTICS_SELECT_PROCESSED_PARTNER_OLD, query = "select t, count(*) "
        + " from Transaction t left join fetch t.user u left join fetch u.marketingInfo m "
        + " where t.state=2 and t.created < :maxDate and t.created >= :minDate and m.partner.id = :partnerId and t.type<>-1 "
        + " group by t.type order by t.successMessage asc ")

})
public class Transaction extends ModelBase {
  private User user;

  private SKU sku;

  private Integer type;

  private String description;

  private String successMessage;

  private String payedAmount;

  private String payedCurrency;

  private String billingRequestParams;

  private String source;

  private byte state = 0;

  public Transaction() {
    super();
    // TODO Auto-generated constructor stub
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public Integer getType() {
    return type;
  }

  public void setType(Integer type) {
    this.type = type;
  }

  public byte getState() {
    return state;
  }

  public void setState(byte state) {
    this.state = state;
  }

  public String getSuccessMessage() {
    return successMessage;
  }

  public void setSuccessMessage(String successMessage) {
    this.successMessage = successMessage;
  }

  @Column(columnDefinition = "longtext")
  public String getBillingRequestParams() {
    return billingRequestParams;
  }

  public void setBillingRequestParams(String billingRequestParams) {
    this.billingRequestParams = billingRequestParams;
  }

  public String getPayedAmount() {
    return payedAmount;
  }

  public void setPayedAmount(String payedAmount) {
    this.payedAmount = payedAmount;
  }

  public String getPayedCurrency() {
    return payedCurrency;
  }

  public void setPayedCurrency(String payedCurrency) {
    this.payedCurrency = payedCurrency;
  }

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "userId")
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
  @JoinColumn(name = "skuId")
  public SKU getSku() {
    return sku;
  }

  public void setSku(SKU sku) {
    this.sku = sku;
  }

}
