package com.kavalok.transactions;

public interface ITransactionStrategy {
  public void beforeCall();

  public void afterCall();

  public void afterError(Throwable e);
}
