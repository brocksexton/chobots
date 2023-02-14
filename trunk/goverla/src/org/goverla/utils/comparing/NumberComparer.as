package org.goverla.utils.comparing {

	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.interfaces.IComparer;
	
	/**
	 * @author Sergey Kovalyov
	 * @author Tyutyunnyk Eugene
	 */
	public class NumberComparer implements IComparer {
		
		public function compare(object1 : Object, object2 : Object) : int {
			var result : int = ComparingResult.EQUALS;
			
			if (!(object1 is Number && object2 is Number)) {
				throw new IllegalArgumentError("Both arguments must be instances of Number, int or uint");
			} else {
				var number1 : Number = object1 as Number;
				var number2 : Number = object2 as Number;

				if (isNaN(number1) && isNaN(number2)) {
					result = ComparingResult.EQUALS;
				}
				if (!isNaN(number1) && isNaN(number2)) {
					result = ComparingResult.GREATER;
				}
				if (isNaN(number1) && !isNaN(number2)) {
					result = ComparingResult.SMALLER;
				}
				if (number1 > number2) {
					result = ComparingResult.GREATER;
				}
				if (number1 < number2) {
					result = ComparingResult.SMALLER;
				}
				if (number1 == number2) {
					result = ComparingResult.EQUALS;
				}
			}			
			
			return result;
		}
	
	}
}