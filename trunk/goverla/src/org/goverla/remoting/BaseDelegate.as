package org.goverla.remoting {
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.utils.ReflectUtil;

	import flash.external.ExternalInterface;
	
	public class BaseDelegate {
		
		public static var defaultFaultHandler : Function;
		
		protected var connectionUrl : String;
		
		public function BaseDelegate(resultHandler : Function, faultHandler : Function) {
			_resultHandler = resultHandler;
			_faultHandler = faultHandler == null ? defaultFaultHandler : faultHandler;	
		}
		
		protected function createConnection() : NetConnection {
			var connection : NetConnection = new NetConnection();
			connection.connect(connectionUrl);
			return connection;
		}
		
		protected function getServiceName(methodName : String) : String {
			var className : String = ReflectUtil.getFullTypeName(this);
			className = ReflectUtil.normalizeTypeName(className);
			return StringUtil.substitute("{0}.{1}", className, methodName);
		}
		
		protected function processArguments(methodName : String, args : ArrayList) : ArrayList {
			return args;
		}
		
		protected function doCall(methodName : String, args : Array) : void	{
			
			ExternalInterface.call("console.log", "Did a call");

			var connection : NetConnection = createConnection();
			
			var flashResponder : Responder = new Responder(_resultHandler, _faultHandler);
			var newArguments : ArrayList = new ArrayList([getServiceName(methodName), flashResponder]);
			newArguments.addItems(processArguments(methodName, new ArrayList(args)));
			
			connection.call.apply(connection, newArguments.toArray());
		}

		private var _resultHandler : Function;
		
		private var _faultHandler : Function;		

	}
	
}