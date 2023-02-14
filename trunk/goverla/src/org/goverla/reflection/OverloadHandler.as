package org.goverla.reflection {
	
	public class OverloadHandler {
		
		[ArrayElementType("Class")]
		private var _types : Array;
		
		private var _handler : Function;
		
		public function OverloadHandler(types : Array, handler : Function) {
			_types = types;
			_handler = handler;
		}
		
		public function get handler() : Function {
			return _handler;
		}
		
		public function match(arguments : Array) : Boolean {
			if (arguments.length != _types.length) {
				return false;
			}
			
			var result : Boolean = true;
				
			for (var i : int = 0; i < _types.length; i++) {
				if ((arguments[i] != null) && !(arguments[i] is _types[i])) {
					result = false;
					break;
				}
				
			}

			return result;
		}
		
	}

}