package com.kavalok.billing.smscoin;

import java.util.List;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

import com.kavalok.billing.SMSPaymentInfo;

@Root(name="slab")
public class CountryInfo implements SMSPaymentInfo{

  @Attribute
  private String country = "";

  @Attribute
  private String country_name = "";

  @Attribute
  private String number = "";

  @Attribute
  private String prefix = "";

  @Attribute
  private String price = "";

  @Attribute
  private String usd = "";

  @Attribute
  private String profit = "";

  @Attribute
  private String vat = "";

  @Attribute
  private String currency = "";

  @Attribute
  private String special = "";

  @ElementList(inline=true, name = "provider", required=false)
  private List<Provider> providers;

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getCountry_name() {
    return country_name;
  }

  public void setCountry_name(String country_name) {
    this.country_name = country_name;
  }

  public String getNumber() {
    return number;
  }

  public void setNumber(String number) {
    this.number = number;
  }

  public String getPrefix() {
    return prefix;
  }

  public void setPrefix(String prefix) {
    this.prefix = prefix;
  }

  public String getPrice() {
    return price;
  }

  public void setPrice(String price) {
    this.price = price;
  }

  public String getUsd() {
    return usd;
  }

  public void setUsd(String usd) {
    this.usd = usd;
  }

  public String getProfit() {
    return profit;
  }

  public void setProfit(String profit) {
    this.profit = profit;
  }

  public String getVat() {
    return vat;
  }

  public void setVat(String vat) {
    this.vat = vat;
  }

  public String getCurrency() {
    return currency;
  }

  public void setCurrency(String currency) {
    this.currency = currency;
  }

  public String getSpecial() {
    return special;
  }

  public void setSpecial(String special) {
    this.special = special;
  }

  public List<Provider> getProviders() {
    return providers;
  }

  public void setProviders(List<Provider> providers) {
    this.providers = providers;
  }

}
