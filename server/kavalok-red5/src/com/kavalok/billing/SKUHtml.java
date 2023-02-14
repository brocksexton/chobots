package com.kavalok.billing;

public class SKUHtml {
  private Long id;

  private Double price;

  private String priceStr;

  private Double discountPrice;

  private String discountPriceStr;

  private Integer term; // 1-1m, 6-6m, 12-12m

  private Integer currency; // 1-USD, 2-EURO, ...

  private String currencySign; // $, euro

  private String currencyText; // USD, EUR, INR

  private String currencyCentsText; // currCentsUSD, currCentsEUR, currCentsINR

  private String name;

  private Integer bugsBonus;

  private String productId; // custom field to pass for billing gateway

  private String specialOfferName;

  private String fileName;

  private String url;

  private String params;
  
  private String itemOfTheMonthName;

  private boolean discount = false;

  private boolean useCents;
  
  private boolean dayMonth;
  
  private Integer offerPrice; 

  private Integer offerDiscountPrice; 

  private String offerCurrency; 

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

  public String getSpecialOfferName() {
    return specialOfferName;
  }

  public void setSpecialOfferName(String specialOfferName) {
    this.specialOfferName = specialOfferName;
  }

  public String getFileName() {
    return fileName;
  }

  public void setFileName(String fileName) {
    this.fileName = fileName;
  }

  public Double getDiscountPrice() {
    return discountPrice;
  }

  public void setDiscountPrice(Double discountPrice) {
    this.discountPrice = discountPrice;
  }

  public String getDiscountPriceStr() {
    return discountPriceStr;
  }

  public void setDiscountPriceStr(String discountPriceStr) {
    this.discountPriceStr = discountPriceStr;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String getParams() {
    return params;
  }

  public void setParams(String params) {
    this.params = params;
  }

  public boolean isDiscount() {
    return discount;
  }

  public void setDiscount(boolean discount) {
    this.discount = discount;
  }

  public boolean isUseCents() {
    return useCents;
  }

  public void setUseCents(boolean useCents) {
    this.useCents = useCents;
  }

  public boolean isDayMonth() {
    return dayMonth;
  }

  public void setDayMonth(boolean dayMonth) {
    this.dayMonth = dayMonth;
  }

  public Integer getOfferPrice() {
    return offerPrice;
  }

  public void setOfferPrice(Integer offerPrice) {
    this.offerPrice = offerPrice;
  }

  public Integer getOfferDiscountPrice() {
    return offerDiscountPrice;
  }

  public void setOfferDiscountPrice(Integer offerDiscountPrice) {
    this.offerDiscountPrice = offerDiscountPrice;
  }

  public String getItemOfTheMonthName() {
    return itemOfTheMonthName;
  }

  public void setItemOfTheMonthName(String itemOfTheMonthName) {
    this.itemOfTheMonthName = itemOfTheMonthName;
  }

  public String getOfferCurrency() {
    return offerCurrency;
  }

  public void setOfferCurrency(String offerCurrency) {
    this.offerCurrency = offerCurrency;
  }

}
