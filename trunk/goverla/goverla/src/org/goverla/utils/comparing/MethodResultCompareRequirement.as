package org.goverla.utils.comparing {

	import org.goverla.interfaces.IRequirement;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class MethodResultCompareRequirement implements IRequirement {
		
		private var _methodName : String;
		private var _value : Object;
		
		public function MethodResultCompareRequirement(methodName : String, value : Object) {
			_methodName = methodName;
			_value = value;
			
		}
		
		public function meet(object : Object) : Boolean {
			return object[_methodName]() == _value;
		}
	
	}

}