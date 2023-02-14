package com.kavalok.db;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import org.hibernate.Session;

import com.kavalok.dao.PartnerDAO;
import com.kavalok.dto.login.MarketingInfoTO;

@Entity
public class MarketingInfo extends ModelBase {
  
  public static MarketingInfo fromTO(MarketingInfoTO marketingInfoTO, Session session)
  {
    if(marketingInfoTO == null)
       return new MarketingInfo();
    MarketingInfo result = new MarketingInfo();
    result.setCampaign(marketingInfoTO.getCampaign());
    result.setKeywords(marketingInfoTO.getKeywords());
    result.setReferrer(marketingInfoTO.getReferrer());
    result.setSource(marketingInfoTO.getSource());
    result.setActivationUrl(marketingInfoTO.getActivationUrl());
    
    result.setPartner(new PartnerDAO(session).findByLogin(marketingInfoTO.getPartner()));
    return result;
  }
  
  private Long id;

  private String source;

  private String campaign;

  private String activationUrl;

  private String keywords;

  private String referrer;
  
  private Partner partner;

  public MarketingInfo() {
    super();
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getCampaign() {
    return campaign;
  }

  public void setCampaign(String campaign) {
    this.campaign = campaign;
  }

  public String getKeywords() {
    return keywords;
  }

  public void setKeywords(String keywords) {
    this.keywords = keywords;
  }
  
  @ManyToOne(fetch=FetchType.LAZY)
  public Partner getPartner() {
    return partner;
  }

  public void setPartner(Partner referer) {
    this.partner = referer;
  }

  public String getReferrer() {
    return referrer;
  }

  public void setReferrer(String ref) {
    this.referrer = ref;
  }

  public String getActivationUrl() {
    return activationUrl;
  }

  public void setActivationUrl(String activationUrl) {
    this.activationUrl = activationUrl;
  }

}
