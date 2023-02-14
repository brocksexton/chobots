package com.kavalok.billing.zapak;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root
public class ZapakRequestParams {
  @Element
  private String order_id = " "; // our transaction id

  @Element
  private String productid = " ";

  @Element
  private String enc = " ";

  @Element
  private String transaction_id = " ";

  @Element
  private String status = " ";

  public String getProductid() {
    return productid;
  }

  public void setProductid(String productid) {
    this.productid = productid;
  }

  public String getEnc() {
    return enc;
  }

  public void setEnc(String enc) {
    this.enc = enc;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getOrder_id() {
    return order_id;
  }

  public void setOrder_id(String order_id) {
    this.order_id = order_id;
  }

  public String getTransaction_id() {
    return transaction_id;
  }

  public void setTransaction_id(String transaction_id) {
    this.transaction_id = transaction_id;
  }

}
