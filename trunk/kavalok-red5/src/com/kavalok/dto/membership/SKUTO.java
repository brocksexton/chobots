package com.kavalok.dto.membership;


public class SKUTO {
  private Long id;

  private Double price;

  private String priceStr;

  private Integer term; // 1-1m, 6-6m, 12-12m

  private Integer currency; // 1-USD, 2-EURO, ...

  private String currencySign; // $, euro

  private String currencyText; // USD, EUR, INR

  private String currencyCentsText; // currCentsUSD, currCentsEUR, currCentsINR

  private String name;

  private Integer bugsBonus;

  private String productId; // custom field to pass for billing gateway

  private Boolean specialOffer; 
  
  private String specialOfferName;

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Integer getCurrency() {
    return currency;
  }

  public void setCurrency(Integer currency) {
    this.currency = currency;
  }

  public String getCurrencySign() {
    return currencySign;
  }

  public void setCurrencySign(String currencySign) {
    this.currencySign = currencySign;
  }

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

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getBugsBonus() {
    return bugsBonus;
  }

  public void setBugsBonus(Integer bugsBonus) {
    this.bugsBonus = bugsBonus;
  }

  public String getProductId() {
    return productId;
  }

  public void setProductId(String productId) {
    this.productId = productId;
  }

  public Integer getTerm() {
    return term;
  }

  public void setTerm(Integer term) {
    this.term = term;
  }

  public String getPriceStr() {
    return priceStr;
  }

  public void setPriceStr(String priceStr) {
    this.priceStr = priceStr;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

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

}
