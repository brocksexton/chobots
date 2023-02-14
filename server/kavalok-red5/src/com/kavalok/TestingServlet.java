package com.kavalok;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.transactions.DefaultTransactionStrategy;
import com.kavalok.xmlrpc.RemoteClient;

public class TestingServlet extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = 9166772327665369872L;

  private static Logger logger = LoggerFactory.getLogger("TestingServlet");

  @Override
  protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // CustomField cf = new CustomField("aaa", "bbb");
    //    
    // System.out.println(cf);
    logger.info("TestingServlet");

    //MessageService ms = new MessageService();

    long now = System.currentTimeMillis();

    for (int i = 0; i <= 2000; i++) {
      // System.out.println(i);
      // // DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
      // CharService dts = new CharService();
      // try {
      // dts.beforeCall();
      //
      // CharTOCache.getInstance().removeCharTO("mezk");
      // dts.getCharView("mezk");
      // CharTOCache.getInstance().removeCharTO("mezk");
      // dts.getCharView("mezk");
      // CharTOCache.getInstance().removeCharTO("mezk");
      // dts.getCharView("mezk");
      // CharTOCache.getInstance().removeCharTO("mezk");
      // dts.getCharView("mezk");
      // CharTOCache.getInstance().removeCharTO("mezk");
      // dts.getCharView("vit");
      // dts.getCharView("mezk");
      // dts.getCharView("go!");
      // CharTOCache.getInstance().removeCharTO("go!");
      // CharTOCache.getInstance().removeCharTO("mezk");
      // CharTOCache.getInstance().removeCharTO("vit");
      //        
      // System.out.println("\n\nDONE!");
      //
      // dts.afterCall();
      // } catch (Exception e) {
      // logger.error("TestingError", e);
      // e.printStackTrace();
      // dts.afterError(e);
      // }
      //      
      // BlockWord result = (BlockWord)TransactionUtil.callTransaction(ms,
      // "addBlockWord",
      // Collections.singletonList((Object)"sometestwordblavla"));
      // TransactionUtil.callTransaction(ms, "removeBlockWord",
      // Collections.singletonList((Object)result.getId().intValue()));

      DefaultTransactionStrategy dts1 = new DefaultTransactionStrategy();
      try {
        dts1.beforeCall();

        new RemoteClient(dts1.getSession(), new Long(1)).KKKKuser(false);

        // User user = new UserDAO(dts1.getSession()).findByLogin("vit");
        // user.setSuperUser(!user.getSuperUser());
        // new UserDAO(dts1.getSession()).makePersistent(user);
        // //new MessageCheck(dts1.getSession()).check("testing some staff!");

        dts1.afterCall();
      } catch (Exception e) {
        logger.error("TestingError", e);
        e.printStackTrace();
        dts1.afterError(e);
      }
    }
    System.err.println(System.currentTimeMillis() - now);

  }
}
