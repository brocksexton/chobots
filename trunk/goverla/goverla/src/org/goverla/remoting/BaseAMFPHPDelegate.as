package org.goverla.remoting {
	
	import org.goverla.managers.ApplicationManager;
	
	public class BaseAMFPHPDelegate extends BaseDelegate {
		
		public static var defaultConnectionUrl : String;
		
		public function BaseAMFPHPDelegate(resultHandler : Function, faultHandler : Function) {
			super(resultHandler, faultHandler);
			connectionUrl = defaultConnectionUrl == null 
				? ApplicationManager.instance.url + "amfphp/gateway.php" : defaultConnectionUrl;
		}
		
	}
	
}