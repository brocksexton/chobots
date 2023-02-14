package org.goverla.utils.comparing {
	
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Objects;

	public class StringEqualRequirement implements IRequirement {
		
		public function StringEqualRequirement(string : String) {
			_string = string.toLowerCase();
		}
		
		public function meet(object : Object) : Boolean {
			var compareString : String = Objects.castToString(object).toLowerCase();
			return compareString == _string;
		}
		
		private var _string : String;
		
	}
	
}