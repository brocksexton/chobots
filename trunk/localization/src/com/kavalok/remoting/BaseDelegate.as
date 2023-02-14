package com.kavalok.remoting {
	
	import com.kavalok.collections.ArrayList;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.Strings;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	
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
			return Strings.substitute("{0}.{1}", className, methodName);
		}
		
		protected function processArguments(methodName : String, args : Array) : Array {
			return args;
		}
		
		protected function doCall(methodName : String, args : Array) : void	{
			var connection : NetConnection = createConnection();
			
			var flashResponder : Responder = new Responder(_resultHandler, _faultHandler);
			var newArguments : ArrayList = new ArrayList();
			newArguments.addItem(getServiceName(methodName));
			newArguments.addItem(flashResponder);
			newArguments.addItems(processArguments(methodName, args));
			
			connection.call.apply(connection, newArguments);
		}

		private var _resultHandler : Function;
		
		private var _faultHandler : Function;		

	}
	
}