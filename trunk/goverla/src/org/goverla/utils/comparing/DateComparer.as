package org.goverla.utils.comparing {

	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.interfaces.IComparer;
	
	/**
	 * @author Sergey Kovalyov
	 * @author Tyutyunnyk Eugene
	 */
	public class DateComparer implements IComparer {
		
		public function compare(object1 : Object, object2 : Object) : int {
			var result : int = ComparingResult.EQUALS;
			
			if (!(object1 is Date && object2 is Date)) {
				throw new IllegalArgumentError("Both arguments must be instances of Date");
			} else {
				var date1 : Date = object1 as Date;
				var date2 : Date = object2 as Date;
				
				if (date1 == null && date2 == null) {
					result = ComparingResult.EQUALS;
				}
				if (date1 != null && date2 == null) {
					result = ComparingResult.GREATER;
				}
				if (date1 == null && date2 != null) {
					result = ComparingResult.SMALLER;
				}
				if (date1 > date2) {
					result = ComparingResult.GREATER;
				}
				if (date1 < date2) {
					result = ComparingResult.SMALLER;
				}
				if (date1 == date2) {
					result = ComparingResult.EQUALS;
				}
			}
			
			return result;
		}
	
	}
}