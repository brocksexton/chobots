/**
 * @author Maxym Hryniv
 */
 
package org.goverla.utils.common {

	public class MethodCallInfo {
		
		private var _object : Object;

		private var _method : Function;

		private var _arguments : Array;
		
		public function MethodCallInfo(object : Object, method : Function, args : Array) {
			_object = object;
			_method = method;
			_arguments = args;
		}
		
		public function get object() : Object {
			return _object;
		}
		
		public function get method() : Function {
			return _method;
		} 
		
		public function get arguments() : Array {
			return _arguments;
		}
	}

}