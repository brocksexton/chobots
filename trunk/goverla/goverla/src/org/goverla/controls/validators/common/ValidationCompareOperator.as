package org.goverla.controls.validators.common {
	
	import mx.utils.StringUtil;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class ValidationCompareOperator {
	      
		public static const EQUAL : String = "equal";
	      
		public static const NOT_EQUAL : String = "notequal";
	      
		public static const GREATER_THAN : String = "greaterthan";
	      
		public static const GREATER_THAN_EQUAL : String = "greaterthanequal";
	      
		public static const LESS_THAN : String = "lessthan";
	      
		public static const LESS_THAN_EQUAL : String = "lessthanequal";
	      
		public static const DATA_TYPE_CHECK : String = "datatypecheck";
	      
		public static function isCompareOperator(operator : String) : Boolean {
			operator = StringUtil.trim(operator).toLowerCase();
			
			if (operator == EQUAL ||
				operator == NOT_EQUAL ||
				operator == GREATER_THAN ||
				operator == GREATER_THAN_EQUAL ||
				operator == LESS_THAN ||
				operator == LESS_THAN_EQUAL ||
				operator == DATA_TYPE_CHECK) {
					return true;
			}
			
			return false;
		}
	
	}
}