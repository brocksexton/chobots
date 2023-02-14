package com.kavalok.services.common;

import org.hibernate.Session;

import com.kavalok.transactions.DefaultTransactionStrategy;

public class DataServiceBase extends ServiceBase {

  private DefaultTransactionStrategy transactionStartegy = new DefaultTransactionStrategy();

  protected Session getSession() {
    return transactionStartegy.getSession();
  }

  @Override
  public void afterCall() {
    transactionStartegy.afterCall();
  }

  @Override
  public void beforeCall() {
    transactionStartegy.beforeCall();
  }

  @Override
  public void afterError(Throwable e) {
    transactionStartegy.afterError(e);
  }

}
