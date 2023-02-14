package com.kavalok.dto.login;

public class MarketingInfoTO {
  private String campaign;
  private String source;
  private String keywords;
  private String referrer;
  private String partner;
  private String activationUrl;
  
  public String getCampaign() {
    return campaign;
  }
  public void setCampaign(String campaign) {
    this.campaign = campaign;
  }
  public String getSource() {
    return source;
  }
  public void setSource(String source) {
    this.source = source;
  }
  public String getKeywords() {
    return keywords;
  }
  public void setKeywords(String keywords) {
    this.keywords = keywords;
  }
  public String getReferrer() {
    return referrer;
  }
  public void setReferrer(String referrer) {
    this.referrer = referrer;
  }
  public String getPartner() {
    return partner;
  }
  public void setPartner(String partner) {
    this.partner = partner;
  }
  public String getActivationUrl() {
    return activationUrl;
  }
  public void setActivationUrl(String activationUrl) {
    this.activationUrl = activationUrl;
  }

}
