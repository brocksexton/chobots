package org.goverla.controls.editable.validators {

	import mx.validators.DateValidator;
	import mx.validators.ValidationResult;
	
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;

	public class BirthDateValidator extends DateValidator {
		
		protected static const INVALID_BIRTH_DATE_ERROR_CODE : String = "invalidBirthDate";
		
		protected static const INVALID_BIRTH_DATE_ERROR_MESSAGE : String = "Enter valid birthday."
		
		protected static const MIN_YEAR : Number = 1900;

		public function BirthDateValidator() {
			super();
		}
		
		public function get invalidBirthDateErrorMessage() : String {
			return _invalidBirthDateErrorMessage;
		}
		
		public function set invalidBirthDateErrorMessage(invalidBirthDateErrorMessage : String) : void {
			_invalidBirthDateErrorMessage = invalidBirthDateErrorMessage;
		}
		
		override protected function doValidation(value : Object) : Array {
			var result : Array = super.doValidation(value);
			
			if (result.length == 0) {
				var string : String = Objects.castToString(value);
				if (!Strings.isBlank(string)) {
					var parsed : Number = Date.parse(string);
					var date : Date = new Date(parsed);
					var valid : Boolean = (date < new Date() && date.fullYear >= MIN_YEAR);
					if (!valid) {
						var validationResult : ValidationResult =
							new ValidationResult(true,
								null,
								INVALID_BIRTH_DATE_ERROR_CODE,
								invalidBirthDateErrorMessage);
						result.push(validationResult);
					}
				}
			}
			
			return result;
		}
		
		private var _invalidBirthDateErrorMessage : String = INVALID_BIRTH_DATE_ERROR_MESSAGE;
		
	}

}