package com.kavalok.errors {
	
	import com.kavalok.utils.Strings;
	
	import flash.utils.*;

	/**
	 * @author Maxym Hryniv
	 */
	public class PropertyAccessError extends ObjectAccessError {
		
		private static var MESSAGE_TEMPLATE : String = "Property '{0}' in object '{1}' of type '{2}' can't be accessed";
	
		private var _propertyName : String;
		
		public function PropertyAccessError(target : Object, propertyName : String) {
			super(target);
			_propertyName = propertyName;
			message = Strings.substitute(MESSAGE_TEMPLATE, propertyName, target.toString(), getQualifiedClassName(target));
		}
		
		public function get propertyName() : String {
			return _propertyName;
		}
	
	}

}