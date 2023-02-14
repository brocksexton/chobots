package com.kavalok.db;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

@Entity
public class SKU extends ModelBase {

  private Double price;
  
  private Double emeralds;

  private Integer term; // 1-1m, 6-6m, 12-12m

  private Integer currency; // 1-USD, 2-EURO, 3-INR ... can be used in billing

  // gateway

  private String currencySign; // $, euro

  private String currencyCode; // "USD", "EUR", "INR" see

  // http://www.iso.org/iso/support/faqs/faqs_widely_used_standards/widely_used_standards_other/currency_codes/currency_codes_list-1.htm

  private String currencyText; // currUSD, currEUR, currINR

  private String currencyCentsText; // currCentsUSD, currCentsEUR, currCentsINR

  private String name;

  private String specialOfferName;

  private Date startDate;

  private Date endDate;

  private Integer bugsBonus;

  private String productId; // custom field to pass for billing gateway

  private Boolean specialOffer;

  private Byte type; // type of SKU. membership/suffitem

  private Long itemTypeId;

  public static final Byte TYPE_MEMBERSHIP = 0;

  public static final Byte TYPE_STUFF = 1;

  public Integer getTerm() {
    return term;
  }

  public void setTerm(Integer term) {
    this.term = term;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }
  
  public Double getEmeralds() {
    return emeralds;
  }

  public void setEmeralds(Double emeralds) {
    this.emeralds = emeralds;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  @Column(columnDefinition = "default 0")
  public Integer getBugsBonus() {
    return bugsBonus;
  }

  public void setBugsBonus(Integer bugsBonus) {
    this.bugsBonus = bugsBonus;
  }

  public Integer getCurrency() {
    return currency;
  }

  public void setCurrency(Integer currency) {
    this.currency = currency;
  }

  @Column(columnDefinition = "varchar(10)")
  public String getCurrencySign() {
    return currencySign;
  }

  public void setCurrencySign(String currencySign) {
    this.currencySign = currencySign;
  }

  public String getProductId() {
    return productId;
  }

  public void setProductId(String productId) {
    this.productId = productId;
  }

  @Column(columnDefinition = "varchar(5)")
  public String getCurrencyText() {
    return currencyText;
  }

  public void setCurrencyText(String currencyText) {
    this.currencyText = currencyText;
  }

  public String getCurrencyCentsText() {
    return currencyCentsText;
  }

  public void setCurrencyCentsText(String currencyCentsText) {
    this.currencyCentsText = currencyCentsText;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  private static final DecimalFormat PRICE_FORMAT;

  static {
    DecimalFormatSymbols symb = DecimalFormatSymbols.getInstance();
    symb.setDecimalSeparator('.');
    PRICE_FORMAT = new DecimalFormat("0.00", symb);
  }

  @Transient
  public String getPriceStr() {
    return PRICE_FORMAT.format(getPrice());
  }

  @Transient
  public String getEmeraldsStr() {
    return PRICE_FORMAT.format(getEmeralds());
  }
  
  public String getCurrencyCode() {
    return currencyCode;
  }

  public void setCurrencyCode(String currencyCode) {
    this.currencyCode = currencyCode;
  }

  @Column(columnDefinition = "boolean default false")
  public Boolean getSpecialOffer() {
    return specialOffer;
  }

  public void setSpecialOffer(Boolean specialOffer) {
    this.specialOffer = specialOffer;
  }

  public String getSpecialOfferName() {
    return specialOfferName;
  }

  public void setSpecialOfferName(String specialOfferName) {
    this.specialOfferName = specialOfferName;
  }

  public Byte getType() {
    return type;
  }

  public void setType(Byte type) {
    this.type = type;
  }

  public Long getItemTypeId() {
    return itemTypeId;
  }

  public void setItemTypeId(Long itemTypeId) {
    this.itemTypeId = itemTypeId;
  }

}
