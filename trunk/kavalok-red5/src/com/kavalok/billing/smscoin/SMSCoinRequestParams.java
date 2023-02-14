package com.kavalok.billing.smscoin;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class SMSCoinRequestParams {
  @Element
  private String country = " ";

  @Element
  private String shortcode = " ";

  @Element
  private String provider = " ";

  @Element
  private String prefix = " ";

  @Element
  private String cost_local = " ";

  @Element
  private String cost_usd = " ";

  @Element
  private String phone = " ";

  @Element
  private String msgid = " ";

  @Element
  private String sid = " ";

  @Element
  private String content = " ";

  @Element
  private String sign = " ";

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getShortcode() {
    return shortcode;
  }

  public void setShortcode(String shortcode) {
    this.shortcode = shortcode;
  }

  public String getProvider() {
    return provider;
  }

  public void setProvider(String provider) {
    this.provider = provider;
  }

  public String getPrefix() {
    return prefix;
  }

  public void setPrefix(String prefix) {
    this.prefix = prefix;
  }

  public String getCost_local() {
    return cost_local;
  }

  public void setCost_local(String cost_local) {
    this.cost_local = cost_local;
  }

  public String getCost_usd() {
    return cost_usd;
  }

  public void setCost_usd(String cost_usd) {
    this.cost_usd = cost_usd;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public String getMsgid() {
    return msgid;
  }

  public void setMsgid(String msgid) {
    this.msgid = msgid;
  }

  public String getSid() {
    return sid;
  }

  public void setSid(String sid) {
    this.sid = sid;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public String getSign() {
    return sign;
  }

  public void setSign(String sign) {
    this.sign = sign;
  }

}
