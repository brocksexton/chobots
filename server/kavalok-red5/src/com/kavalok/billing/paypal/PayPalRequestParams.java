package com.kavalok.billing.paypal;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class PayPalRequestParams {
  @Element
  private String item_number = " ";

  @Element
  private String residence_country = " ";

  @Element
  private String verify_sign = " ";

  @Element
  private String prefix = " ";

  @Element
  private String payment_status = " ";

  @Element
  private String business = " ";

  @Element
  private String payer_id = " ";

  @Element
  private String first_name = " ";

  @Element
  private String shipping = " ";

  @Element
  private String payer_email = " ";

  @Element
  private String mc_fee = " ";

  @Element
  private String txn_id = " ";

  @Element
  private String quantity = " ";

  @Element
  private String receiver_email = " ";

  @Element
  private String notify_version = " ";

  @Element
  private String txn_type = " ";

  @Element
  private String test_ipn = " ";

  @Element
  private String payer_status = " ";

  @Element
  private String mc_currency = " ";

  @Element
  private String mc_gross = " ";

  @Element
  private String custom = " ";

  @Element
  private String payment_date = " ";

  @Element
  private String charset = " ";

  @Element
  private String mc_gross1 = " ";

  @Element
  private String tax = " ";

  @Element
  private String item_name = " ";

  @Element
  private String last_name = " ";

  @Element
  private String payment_type = " ";

  @Element
  private String receiver_id = " ";

  public String getItem_number() {
    return item_number;
  }

  public void setItem_number(String item_number) {
    this.item_number = item_number;
  }

  public String getResidence_country() {
    return residence_country;
  }

  public void setResidence_country(String residence_country) {
    this.residence_country = residence_country;
  }

  public String getVerify_sign() {
    return verify_sign;
  }

  public void setVerify_sign(String verify_sign) {
    this.verify_sign = verify_sign;
  }

  public String getPrefix() {
    return prefix;
  }

  public void setPrefix(String prefix) {
    this.prefix = prefix;
  }

  public String getPayment_status() {
    return payment_status;
  }

  public void setPayment_status(String payment_status) {
    this.payment_status = payment_status;
  }

  public String getBusiness() {
    return business;
  }

  public void setBusiness(String business) {
    this.business = business;
  }

  public String getPayer_id() {
    return payer_id;
  }

  public void setPayer_id(String payer_id) {
    this.payer_id = payer_id;
  }

  public String getFirst_name() {
    return first_name;
  }

  public void setFirst_name(String first_name) {
    this.first_name = first_name;
  }

  public String getShipping() {
    return shipping;
  }

  public void setShipping(String shipping) {
    this.shipping = shipping;
  }

  public String getPayer_email() {
    return payer_email;
  }

  public void setPayer_email(String payer_email) {
    this.payer_email = payer_email;
  }

  public String getMc_fee() {
    return mc_fee;
  }

  public void setMc_fee(String mc_fee) {
    this.mc_fee = mc_fee;
  }

  public String getTxn_id() {
    return txn_id;
  }

  public void setTxn_id(String txn_id) {
    this.txn_id = txn_id;
  }

  public String getQuantity() {
    return quantity;
  }

  public void setQuantity(String quantity) {
    this.quantity = quantity;
  }

  public String getReceiver_email() {
    return receiver_email;
  }

  public void setReceiver_email(String receiver_email) {
    this.receiver_email = receiver_email;
  }

  public String getNotify_version() {
    return notify_version;
  }

  public void setNotify_version(String notify_version) {
    this.notify_version = notify_version;
  }

  public String getTxn_type() {
    return txn_type;
  }

  public void setTxn_type(String txn_type) {
    this.txn_type = txn_type;
  }

  public String getTest_ipn() {
    return test_ipn;
  }

  public void setTest_ipn(String test_ipn) {
    this.test_ipn = test_ipn;
  }

  public String getPayer_status() {
    return payer_status;
  }

  public void setPayer_status(String payer_status) {
    this.payer_status = payer_status;
  }

  public String getMc_currency() {
    return mc_currency;
  }

  public void setMc_currency(String mc_currency) {
    this.mc_currency = mc_currency;
  }

  public String getMc_gross() {
    return mc_gross;
  }

  public void setMc_gross(String mc_gross) {
    this.mc_gross = mc_gross;
  }

  public String getCustom() {
    return custom;
  }

  public void setCustom(String custom) {
    this.custom = custom;
  }

  public String getPayment_date() {
    return payment_date;
  }

  public void setPayment_date(String payment_date) {
    this.payment_date = payment_date;
  }

  public String getCharset() {
    return charset;
  }

  public void setCharset(String charset) {
    this.charset = charset;
  }

  public String getMc_gross1() {
    return mc_gross1;
  }

  public void setMc_gross1(String mc_gross1) {
    this.mc_gross1 = mc_gross1;
  }

  public String getTax() {
    return tax;
  }

  public void setTax(String tax) {
    this.tax = tax;
  }

  public String getItem_name() {
    return item_name;
  }

  public void setItem_name(String item_name) {
    this.item_name = item_name;
  }

  public String getLast_name() {
    return last_name;
  }

  public void setLast_name(String last_name) {
    this.last_name = last_name;
  }

  public String getPayment_type() {
    return payment_type;
  }

  public void setPayment_type(String payment_type) {
    this.payment_type = payment_type;
  }

  public String getReceiver_id() {
    return receiver_id;
  }

  public void setReceiver_id(String receiver_id) {
    this.receiver_id = receiver_id;
  }
}
