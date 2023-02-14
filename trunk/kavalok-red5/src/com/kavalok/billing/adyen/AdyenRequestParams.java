package com.kavalok.billing.adyen;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class AdyenRequestParams {
  @Element
  private String merchantReference = " "; // our transaction id

  @Element
  private String skinCode = " ";

  @Element
  private String shopperLocale = " ";

  @Element
  private String authResult = " ";

  @Element
  private String pspReference = " ";

  @Element
  private String live = " ";

  @Element
  private String eventCode = " ";

  @Element
  private String eventDate = " ";

  @Element
  private String paymentMethod = " ";

  @Element
  private String operations = " ";

  @Element
  private String reason = " ";

  @Element
  private String success = " ";

  public String getMerchantReference() {
    return merchantReference;
  }

  public void setMerchantReference(String merchantReference) {
    this.merchantReference = merchantReference;
  }

  public String getSkinCode() {
    return skinCode;
  }

  public void setSkinCode(String skinCode) {
    this.skinCode = skinCode;
  }

  public String getShopperLocale() {
    return shopperLocale;
  }

  public void setShopperLocale(String shopperLocale) {
    this.shopperLocale = shopperLocale;
  }

  public String getAuthResult() {
    return authResult;
  }

  public void setAuthResult(String authResult) {
    this.authResult = authResult;
  }

  public String getPspReference() {
    return pspReference;
  }

  public void setPspReference(String pspReference) {
    this.pspReference = pspReference;
  }

  public String getLive() {
    return live;
  }

  public void setLive(String live) {
    this.live = live;
  }

  public String getEventCode() {
    return eventCode;
  }

  public void setEventCode(String eventCode) {
    this.eventCode = eventCode;
  }

  public String getEventDate() {
    return eventDate;
  }

  public void setEventDate(String eventDate) {
    this.eventDate = eventDate;
  }

  public String getPaymentMethod() {
    return paymentMethod;
  }

  public void setPaymentMethod(String paymentMethod) {
    this.paymentMethod = paymentMethod;
  }

  public String getOperations() {
    return operations;
  }

  public void setOperations(String operations) {
    this.operations = operations;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public String getSuccess() {
    return success;
  }

  public void setSuccess(String success) {
    this.success = success;
  }

}
