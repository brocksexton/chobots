package com.kavalok.billing.transaction;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class CitizenMembershipProduct {

  public CitizenMembershipProduct() {
    super();
  }
  
  public CitizenMembershipProduct(Integer months) {
    super();
    this.months = months;
  }

  @Element
  private Integer months;

  public Integer getMonths() {
    return months;
  }

  public void setMonths(Integer months) {
    this.months = months;
  }
  

}
