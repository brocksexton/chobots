package org.goverla.managers {
	
	import flash.errors.IllegalOperationError;
	
	import mx.core.Application;
	
	public class ApplicationManager {
		
		private static var _instance : ApplicationManager;
		
		public static function get instance() : ApplicationManager {
			if (_instance == null) {
				_instance = new ApplicationManager();
			}
			return _instance;
		}
		
		public function get protocol() : String {
			return _protocol;
		}
		
		public function get host() : String {
			return _host;
		}
		
		public function get port() : String {
			return _port;
		}
		
		public function get contextRoot() : String {
			return _contextRoot;
		}
		
		public function get url() : String {
			return _url;
		}
		
		public function ApplicationManager() {
			if (_instance != null) {
				throw new IllegalOperationError("Singleton!");
			}
			
			if (Application.application == null) {
				throw new IllegalOperationError("Can't create ApplicationManager before Application.applicationComplete dispatched!");
			}
			
			var url : String = Application.application.url;
			var re : RegExp = new RegExp("(https?)://([^/:]+):?([0-9]*)/(.+)", "i");
			var result : Object = re.exec(url);

			if (result != null) {
				_protocol = result[1];
				_host = result[2];
				_port = result[3];
				
				var postfix : String = result[4];
				var index : int = postfix.lastIndexOf("/");
	            
				if (index > -1) {
					_contextRoot = postfix.substr(0, index + 1);
				}
				
				index = _contextRoot.lastIndexOf("bin");
				
				if (index > -1) {
					_contextRoot = _contextRoot.substr(0, index);
				}
				
				_url = protocol + "://" + host + (port != null ? ":" + port : "") + "/" + (contextRoot != null ? contextRoot : "");
			}
		}
		
		private var _protocol : String;
		
		private var _host : String;
		
		private var _port : String
		
		private var _contextRoot : String;
		
		private var _url : String;
		
	}
	
}