package org.goverla.controls.editable.validators {

	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;

	public class ICQValidator extends Validator {

		protected static const FIRST_DIGIT_EXPRESSION : RegExp = /^[\d]/g;

		protected static const LAST_DIGIT_EXPRESSION : RegExp = /[\d]$/g;

		protected static const DIGIT_EXPRESSION : RegExp = /[\d]/g;

		protected static const DOUBLE_DASH_EXPRESSION : RegExp = /[-]{2,}/g;
		
		protected static const NOT_DIGIT_AND_DASH_EXPRESSION : RegExp = /[^-\d]/g;

		protected static const INVALID_ICQ_ERROR_CODE : String = "invalidICQ";

		protected static const INVALID_ICQ_ERROR_MESSAGE : String = "Invalid ICQ Number";
		
		public function ICQValidator() {
			super();
		}
		
		public function get invalidICQErrorMessage() : String {
			return _invalidICQErrorMessage;
		}
		
		public function set invalidICQErrorMessage(invalidICQErrorMessage : String) : void {
			_invalidICQErrorMessage = invalidICQErrorMessage;
		}
		
		override protected function doValidation(value : Object) : Array {
			var result : Array = super.doValidation(value);
			var string : String = Objects.castToString(value);
			
			if (result.length == 0 && !(Strings.isBlank(string) && !required)) {
				var firstDigitMatches : Array = string.match(FIRST_DIGIT_EXPRESSION);
				var lastDigitMatches : Array = string.match(LAST_DIGIT_EXPRESSION);
				var digitMatches : Array = string.match(DIGIT_EXPRESSION);
				var doubleDashMatches : Array = string.match(DOUBLE_DASH_EXPRESSION);
				var notDigitAndDashMatches : Array = string.match(NOT_DIGIT_AND_DASH_EXPRESSION);
				var valid : Boolean = (firstDigitMatches.length > 0 &&
					lastDigitMatches.length > 0 &&
					digitMatches.length > 4 &&
					doubleDashMatches.length == 0 &&
					notDigitAndDashMatches.length == 0);
				if (!valid) {
					var validationResult : ValidationResult =
						new ValidationResult(true,
							null,
							INVALID_ICQ_ERROR_CODE,
							_invalidICQErrorMessage);
					result.push(validationResult);
				}
			}
			
			return result;
		}
		
		private var _invalidICQErrorMessage : String = INVALID_ICQ_ERROR_MESSAGE;

	}

}