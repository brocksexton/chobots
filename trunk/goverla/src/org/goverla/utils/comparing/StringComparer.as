package org.goverla.utils.comparing {

	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.interfaces.IComparer;
	
	/**
	 * @author Sergey Kovalyov
	 * @author Tyutyunnyk Eugene
	 */
	public class StringComparer implements IComparer {
		
		public function compare(object1 : Object, object2 : Object) : int {
			var result : int = ComparingResult.EQUALS;
			
			if (!(object1 is String && object2 is String)) {
				throw new IllegalArgumentError("Both arguments must be instances of String");
			} else {
				var string1 : String = object1 as String;
				var string2 : String = object2 as String;
				
				if (string1 == null && string2 == null) {
					result = ComparingResult.EQUALS;
				}
				if (string1 != null && string2 == null) {
					result = ComparingResult.GREATER;
				}
				if (string1 == null && string2 != null) {
					result = ComparingResult.SMALLER;
				}
				if (string1 > string2) {
					result = ComparingResult.GREATER;
				}
				if (string1 < string2) {
					result = ComparingResult.SMALLER;
				}
				if (string1 == string2) {
					result = ComparingResult.EQUALS;
				}
			}
			
			return result;
		}
	
	}

}