package com.kavalok.xmlrpc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RpcThread implements Runnable {
  private static Logger logger = LoggerFactory.getLogger(RpcThread.class);
  
  private ClientBase client;
  private String method;
  private Object[] parameters;
  
  public RpcThread(ClientBase client, String method, Object[] parameters) {
    super();
    this.client = client;
    this.method = method;
    this.parameters = parameters;
  }

  @Override
  public void run() {
    try
    {
      client.invoke(method, parameters);
    }
    catch(Exception e)
    {
      logger.error(e.getMessage(), e);
    }
  }

}
