package org.goverla.remoting {
	
	import flash.net.NetConnection;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.utils.ReflectUtil;
	
	public class BaseRed5Delegate extends BaseDelegate {
		
		private static const METHOD_NAME : String = "call";
		
		public static var defaultConnectionUrl : String;
		
		private static var _netConnection : NetConnection;
		
		public static function get netConnection() : NetConnection {
			if (_netConnection == null) {
				_netConnection = new NetConnection();
			}
			return _netConnection;
		}
		
		public function BaseRed5Delegate(resultHandler : Function, faultHandler : Function) {
			super(resultHandler, faultHandler);
			connectionUrl = defaultConnectionUrl;
		}
		
		protected override function createConnection(): NetConnection {
			return netConnection;
		}
		
		protected override function getServiceName(methodName : String) : String {
			return METHOD_NAME;
		}
		
		protected override function processArguments(methodName : String, args : ArrayList) : ArrayList {
			var newArgs : ArrayList = new ArrayList();
			var className : String = ReflectUtil.getFullTypeName(this);
			className = ReflectUtil.normalizeTypeName(className);
			newArgs.addItem(className);
			newArgs.addItem(methodName);
			newArgs.addItem(args.toArray());
			return newArgs;
		}
		
	}
	
}