package com.kavalok.errors {
	
	import com.kavalok.utils.Strings;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class ObjectAccessError extends Error {
		
		private static var MESSAGE_TEMPLATE : String = "Object '{0}' of type '{1}' can't be accessed";
		
		private var _target : Object;
		
		public function ObjectAccessError(target : Object) {
			super();
			_target = target;
			message = Strings.substitute(MESSAGE_TEMPLATE, target.toString(), getQualifiedClassName(target));
		}
		
		public function get target() : Object {
			return _target;
		}
		
	}

}