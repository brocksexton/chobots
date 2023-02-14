package com.kavalok.transactions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import org.red5.server.net.rtmp.RTMPClient;

import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class Test {
  public static void main(String[] args) throws IOException {

    RTMPClient client = new RTMPClient();
    client.connect("192.168.0.45",1935,"red5java");
    
    if (1 == 1)
      return;

    URL u = new URL("http://server.cpmstar.com/action.aspx?advertiserid=749&gif=1");
    URLConnection uc = u.openConnection();
    uc.setRequestProperty("Referer", "http://www.jguru.com/");
    uc.setDoOutput(true);
    BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream()));
    String res = in.readLine();
    in.close();
    System.err.println(res);

    if (1 == 1) {
      return;
    }

    UserAdapter user = UserManager.getInstance().getCurrentUser();
    user.setLogin("fishalate");
    while (true);

    // Iterator<IClient> clients =
    // KavalokApplication.getInstance().getClients().iterator();
    // int i=0;
    // while (clients.hasNext()) {
    // IClient client = clients.next();
    // UserAdapter user = (UserAdapter)
    // client.getAttribute(UserManager.ADAPTER);
    // if(user!=null){
    // i++;
    // System.err.println(user.getLogin()+ " "+ user.getLastTick());
    // user.getLogin();
    // user.getLastChatMessages();
    // user.getLastTick();
    // }
    // }
    // System.err.println("Clients count:
    // "+KavalokApplication.getInstance().getClients().size());
    // System.err.println("Alive Clients count: "+i);
  }
}
