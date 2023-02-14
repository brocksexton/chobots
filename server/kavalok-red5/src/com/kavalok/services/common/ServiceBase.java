package com.kavalok.services.common;

import com.kavalok.transactions.ITransactionStrategy;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public abstract class ServiceBase implements ITransactionStrategy {
  
  public UserAdapter getAdapter()
  {
    return UserManager.getInstance().getCurrentUser();
  }
  
  public void beforeCall() {
  }

  public void afterCall() {

  }

  public void afterError(Throwable e) {
  }
}
