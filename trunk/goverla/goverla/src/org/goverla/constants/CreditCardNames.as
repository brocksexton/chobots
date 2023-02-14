package org.goverla.constants {

	import mx.utils.StringUtil;
	
	public class CreditCardNames {
	
		public static const VISA : String = "Visa";
	
		public static const MASTER_CARD : String = "Master Card"; 
	
		public static const AMERICAN_EXPRESS : String = "American Express";
	
		public static const DISCOVER : String	= "Discover";
	
		public static const DINERS_CLUB : String = "Diners Club";
		
		public static function isCreditCardName(name : String) : Boolean {
			name = StringUtil.trim(name).toLowerCase();
			
			if (name == VISA.toLowerCase() ||
				name == MASTER_CARD.toLowerCase() ||
				name == AMERICAN_EXPRESS.toLowerCase() ||
				name == DISCOVER.toLowerCase() ||
				name == DINERS_CLUB.toLowerCase()) {
					return true;
			}
			
			return false;
		}	
		
	}
}