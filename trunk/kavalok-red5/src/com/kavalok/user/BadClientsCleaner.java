package com.kavalok.user;

import java.util.Set;
import java.util.TimerTask;

import org.red5.server.api.IClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.KavalokApplication;

public class BadClientsCleaner extends TimerTask {

  public static final int DELAY = 10 * 20000 * 1000;

  public static Logger logger = LoggerFactory.getLogger(BadClientsCleaner.class);

  @Override
  public void run() {
    try {
      System.err.println("BadClientsCleaner start");
      Set<IClient> clients = KavalokApplication.getInstance().getClients();
      for (IClient client : clients) {
        
        
        UserAdapter user = (UserAdapter) client.getAttribute(UserManager.ADAPTER);
        if (user == null) {
          System.err.println("User attribute was null, cleaning client: " + client);
          try {
            //client.disconnect();
          } catch (Exception e) {
            // TODO: handle exception
          }
        } else if (user.getLogin() == null && user.getUserId() == null) {
          System.err.println("User attribute is empty, cleaning client: " + client);
          try {
            client.disconnect();
          } catch (Exception e) {
            // TODO: handle exception
          }

        }
      }

      System.err.println("BadClientsCleaner finish");
    } catch (Exception e) {
      e.printStackTrace();
      logger.error(e.getMessage(), e);
    }
  }

}
