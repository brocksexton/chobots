package com;

import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.net.rtmp.RTMPClient;


public class TestClient {
	     public static void main(String[] args) {


	         RTMPClient client = new RTMPClient();
	         IPendingServiceCallback _callback = new MyCallback();
	          client.connect("localhost",4000,"kavalok");
	            Object[] params = new Object[3];
	            params[0] = "zzz";
	            params[1] = "zzzz";
	            params[2] = "EN";
	            client.invoke("login",_callback);
	     }

	     static class MyCallback implements IPendingServiceCallback {
	         public void resultReceived(IPendingServiceCall call) {
	             System.out.println("result 	Received"+call.getServiceMethodName()+":"+call.getServiceName()+":"+call.getStatus()+":"+call.getResult());
	         }
	     }

}
