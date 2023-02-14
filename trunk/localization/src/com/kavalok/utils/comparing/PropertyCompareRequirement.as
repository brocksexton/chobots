package com.kavalok.utils.comparing {
	
	import com.kavalok.interfaces.IRequirement;
	import com.kavalok.utils.Objects;
	
	/**
	 * @author Maxym Hryniv
	 */ 
	public class PropertyCompareRequirement implements IRequirement {
	
		private var _propertyName : String;
		
		private var _propertyValue : Object;
	
		public function PropertyCompareRequirement(properyName : String, propertyValue : Object) {
			_propertyName = properyName;
			_propertyValue = propertyValue;
		}
		
		public function get propertyValue() : Object {
			return _propertyValue;
		}
		
		public function set propertyValue(value : Object) : void {
			_propertyValue = value;
		}
		
		public function get propertyName() : String {
			return _propertyName;
		}
		
		public function set propertyName(value : String) : void {
			_propertyName = value;
		}
		
		public function meet(object : Object) : Boolean {
			return Objects.getProperty(object, _propertyName) === propertyValue;
		}
	
	}
}