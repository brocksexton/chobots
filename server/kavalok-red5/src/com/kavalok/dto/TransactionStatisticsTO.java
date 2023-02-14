package com.kavalok.dto;

public class TransactionStatisticsTO {

  private Double sum;

  private Integer count;

  private String type;

  public TransactionStatisticsTO(String type, Integer count, Double sum) {
    super();
    this.type = type;
    this.count = count;
    this.sum = sum;
  }

  public Double getSum() {
    return sum;
  }

  public void setSum(Double sum) {
    this.sum = sum;
  }

  public Integer getCount() {
    return count;
  }

  public void setCount(Integer count) {
    this.count = count;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

}
