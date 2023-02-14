package com.kavalok.utils.comparing {
	
	import com.kavalok.interfaces.IComparer;

	public class PropertyComparer implements IComparer {
		
		public function PropertyComparer(propertyName : String) {
			_propertyName = propertyName;
		}
		
		public function compare(object1 : Object, object2 : Object) : int {
			if (object1[_propertyName] > object2[_propertyName]) 
				return ComparingResult.GREATER;
			if (object1[_propertyName] < object2[_propertyName]) 
				return ComparingResult.SMALLER;
			
			return ComparingResult.EQUALS;
		}
		
		private var _propertyName : String;
		
	}
	
}