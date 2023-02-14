package org.goverla.controls.editable.validators {

	import mx.validators.EmailValidator;
	import mx.validators.ValidationResult;
	
	import org.goverla.utils.Objects;

	public class AIMValidator extends EmailValidator {

		protected static const AIM_EXPRESSION : RegExp = /^[a-zA-Z][\w]{0,15}$/g;
		
		protected static const INVALID_AIM_ERROR_CODE : String = "invalidAIM";
		
		protected static const INVALID_AIM_ERROR_MESSAGE : String = "Invalid AIM screen name or email address used as a screen name";
		
		public function AIMValidator() {
			super();
		}
		
		public function get invalidAIMErrorMessage() : String {
			return _invalidAIMErrorMessage;
		}
		
		public function set invalidAIMErrorMessage(invalidAIMErrorMessage : String) : void {
			_invalidAIMErrorMessage = invalidAIMErrorMessage;
		}
		
		override protected function doValidation(value : Object) : Array {
			var result : Array = [];
			
			var string : String = Objects.castToString(value);
			var aimMatches : Array = string.match(AIM_EXPRESSION);
			var valid : Boolean = (aimMatches.length > 0);

			if (!valid) {
				result = super.doValidation(value);
				if (result.length != 0) {
					var validationResult : ValidationResult =
						new ValidationResult(true,
							null,
							INVALID_AIM_ERROR_CODE,
							invalidAIMErrorMessage);
					result = [validationResult];
				}
			}

			return result;
		}
		
		private var _invalidAIMErrorMessage : String = INVALID_AIM_ERROR_MESSAGE;
		
	}

}