package com.kavalok.utils;

import java.util.ArrayList;
import java.util.LinkedHashMap;

import org.red5.io.utils.ObjectMap;
import org.red5.server.api.so.ISharedObject;

import com.kavalok.KavalokApplication;
import com.kavalok.sharedObjects.SOListener;

public class SOUtil {

	public static final Integer getNumConnectedChars(String sharedObjectId) {
		ISharedObject sharedObject = KavalokApplication.getInstance().getSharedObject(sharedObjectId);
		if (sharedObject != null) {
			SOListener listener = SOListener.getListener(sharedObject);
			return listener.getConnectedChars().size();
		} else {
			return 0;
		}
	}
	
	public static final void sendToSharedObject(String sharedObjectId,
			String clientId, String method, String stateName,
			ObjectMap<String, Object> state) {

		LinkedHashMap<Integer, Object> methodArgs = new LinkedHashMap<Integer, Object>();
		methodArgs.put(0, stateName);
		methodArgs.put(1, state);

		ArrayList<Object> args = new ArrayList<Object>();
		args.add(clientId);
		args.add(method);
		args.add(methodArgs);

		ISharedObject so = KavalokApplication.getInstance().getSharedObject(
				sharedObjectId);
		so.sendMessage(SOListener.SEND_STATE, args);
	}

	public static final void callSharedObject(String sharedObjectId,
			String clientId, String method, Object ...params) {
	  ISharedObject so = KavalokApplication.getInstance().getSharedObject(
	      sharedObjectId);

		callSharedObject(so, clientId, method,  params);
	}

	public static void sendState(ISharedObject so, String clientId, String method, String stateName, ObjectMap<String, Object> state) {
	  ArrayList<Object> args = new ArrayList<Object>();
	  args.add(clientId);
	  args.add(method);
	  LinkedHashMap<Integer, Object> methodArgs = new LinkedHashMap<Integer, Object>();
	  args.add(methodArgs);
	  methodArgs.put(0, stateName);
	  methodArgs.put(1, state);
	  methodArgs.put(2, false);
	  
	  so.sendMessage(SOListener.SEND_STATE, args);
	}
	
  public static void callSharedObject(ISharedObject so, String clientId, String method, Object... params) {
    ArrayList<Object> args = new ArrayList<Object>();
    args.add(clientId);
    args.add(method);
    LinkedHashMap<Integer, Object> methodArgs = new LinkedHashMap<Integer, Object>();
    for(int i = 0; i < params.length; i++)
       methodArgs.put(i, params[i]);
    
    args.add(methodArgs);
		so.sendMessage(SOListener.SEND, args);
  }

}
