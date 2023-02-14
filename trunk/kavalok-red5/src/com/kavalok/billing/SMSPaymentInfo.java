package com.kavalok.billing;

public interface SMSPaymentInfo {

  public String getNumber();

  public String getPrice();

  public String getPrefix();

  public String getCurrency();

}
