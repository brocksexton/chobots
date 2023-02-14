package com.kavalok.dto;

import java.util.List;

public class PagedResult<T> {

  private Integer totalItems;

  private List<T> data;

  public PagedResult(Integer totalItems, List<T> data) {
    super();
    this.totalItems = totalItems;
    this.data = data;
  }

  public Integer getTotalItems() {
    return totalItems;
  }

  public void setTotalItems(Integer totalItems) {
    this.totalItems = totalItems;
  }

  public List<T> getData() {
    return data;
  }

  public void setData(List<T> data) {
    this.data = data;
  }
}
