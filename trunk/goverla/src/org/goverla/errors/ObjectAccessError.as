package org.goverla.errors {
	
	import flash.utils.*;
	
	import mx.utils.StringUtil;

	/**
	 * @author Maxym Hryniv
	 */
	public class ObjectAccessError extends Error {
		
		private static var MESSAGE_TEMPLATE : String = "Object '{0}' of type '{1}' can't be accessed";
		
		private var _target : Object;
		
		public function ObjectAccessError(target : Object) {
			super();
			_target = target;
			message = StringUtil.substitute(MESSAGE_TEMPLATE, target.toString(), getQualifiedClassName(target));
		}
		
		public function get target() : Object {
			return _target;
		}
		
	}

}