package org.goverla.controls.editable.validators {

	import mx.validators.RegExpValidator;

	public class SkypeValidator extends RegExpValidator {

		protected static const SKYPE_EXPRESSION : String = "^[a-zA-Z][-,.\\w]{0,31}$";
		
		protected static const SKYPE_NO_MATCH_ERROR : String = "Invalid Skype Name";
		
		public function SkypeValidator() {
			super();
			
			expression = SKYPE_EXPRESSION;
			noMatchError = SKYPE_NO_MATCH_ERROR;
		}
		
	}

}