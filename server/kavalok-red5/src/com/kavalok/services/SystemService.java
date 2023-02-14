package com.kavalok.services;

import java.util.Date;

import com.kavalok.services.common.ServiceBase;
import com.kavalok.user.UserManager;

public class SystemService extends ServiceBase {

  public Date getSystemDate() {
    return new Date();
  }

  public void clientTick() {
    UserManager.getInstance().getCurrentUser().setLastTick(new Date());
  }

}
