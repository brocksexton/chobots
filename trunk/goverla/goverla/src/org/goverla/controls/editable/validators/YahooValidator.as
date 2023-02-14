package org.goverla.controls.editable.validators {

	import mx.validators.RegExpValidator;

	public class YahooValidator extends RegExpValidator {

		protected static const YAHOO_EXPRESSION : String = "^[a-zA-Z][-,.\\w]{0,31}$";
		
		protected static const YAHOO_NO_MATCH_ERROR : String = "Invalid Yahoo! ID";
		
		public function YahooValidator() {
			super();
			
			expression = YAHOO_EXPRESSION;
			noMatchError = YAHOO_NO_MATCH_ERROR;
		}
		
	}

}