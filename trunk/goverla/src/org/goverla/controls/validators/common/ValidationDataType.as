package org.goverla.controls.validators.common {
	
	import mx.utils.StringUtil;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class ValidationDataType {
		
		public static const STRING : String = "string";
		
		public static const REAL : String = "real";
		
		public static const INTEGER : String = "int";
		
		public static const DATE : String = "date";
		
		public static function isValidationDataType(type : String) : Boolean {
			type = StringUtil.trim(type).toLowerCase();
			
			if (type == STRING ||
				type == REAL ||
				type == INTEGER ||
				type == DATE) {
					return true;
			}
			
			return false;
		}
	
	}
}