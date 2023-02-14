package com.kavalok.services;

import org.hibernate.Session;
import org.red5.server.api.so.ISharedObject;

import com.kavalok.KavalokApplication;
import com.kavalok.dao.ServerDAO;
import com.kavalok.db.Server;
import com.kavalok.dto.StateInfoTO;
import com.kavalok.services.common.ServiceBase;
import com.kavalok.sharedObjects.SOListener;
import com.kavalok.utils.HibernateUtil;
import com.kavalok.utils.SOUtil;
import com.kavalok.xmlrpc.RemoteClient;

public class SOService extends ServiceBase {

  public StateInfoTO getState(String sharedObjectId) {
    ISharedObject sharedObject = KavalokApplication.getInstance().getSharedObject(sharedObjectId);
    SOListener listener = SOListener.getListener(sharedObject);
    return new StateInfoTO(listener.getState(), listener.getConnectedChars());
  }
  
  public Integer getNumConnectedChars(String sharedObjectId, String serverName) {
	  if (serverName.length() == 0) {
		  return SOUtil.getNumConnectedChars(sharedObjectId);
	  } else {
		  Session session = HibernateUtil.getSessionFactory().openSession();
		  Server server = new ServerDAO(session).findByName((String) serverName);
		  session.close();
		  
		  RemoteClient client = new RemoteClient(server);
		  return client.getNumConnectedChars(sharedObjectId);
	  }
  }
}
