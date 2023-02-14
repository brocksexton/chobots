package com.kavalok.billing.smscoin;

import java.util.Date;
import java.util.List;

import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "feed")
public class ServiceInfo {

  @ElementList(inline=true, name = "slab")
  private List<CountryInfo> countries;
  
  private Date lastLoadTime = new Date();

  public List<CountryInfo> getCountries() {
    return countries;
  }

  public void setCountries(List<CountryInfo> countries) {
    this.countries = countries;
  }

  public Date getLastLoadTime() {
    return lastLoadTime;
  }

  public void setLastLoadTime(Date lastLoadTime) {
    this.lastLoadTime = lastLoadTime;
  }

}
