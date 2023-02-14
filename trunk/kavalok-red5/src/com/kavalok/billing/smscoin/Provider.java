package com.kavalok.billing.smscoin;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;

import com.kavalok.billing.SMSPaymentInfo;

@Root(name = "provider")
public class Provider  implements SMSPaymentInfo{
  @Attribute
  private String code="";

  @Attribute
  private String name="";

  @Attribute
  private String number="";

  @Attribute
  private String prefix="";

  @Attribute
  private String price="";

  @Attribute
  private String usd="";

  @Attribute
  private String profit="";

  @Attribute
  private String vat="";

  @Attribute
  private String currency="";

  @Attribute
  private String special="";

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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
}
