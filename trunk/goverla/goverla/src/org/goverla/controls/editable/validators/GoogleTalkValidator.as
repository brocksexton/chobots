package org.goverla.controls.editable.validators {

	import mx.validators.EmailValidator;
	import mx.validators.ValidationResult;
	
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;

	public class GoogleTalkValidator extends EmailValidator {
		
		protected static const GOOGLE_TALK_ACCOUNT_DOMAIN : String = "@gmail.com";
		
		protected static const INVALID_GOOGLE_TALK_ERROR_CODE : String = "invalidGoogleTalk";
		
		protected static const INVALID_GOOGLE_TALK_ERROR_MESSAGE : String = "Invalid Google Talk";
		
		public function GoogleTalkValidator() {
			super();
		}
		
		public function get invalidGoogleTalkErrorMessage() : String {
			return _invalidGoogleTalkErrorMessage;
		}
		
		public function set invalidGoogleTalkErrorMessage(invalidGoogleTalkErrorMessage : String) : void {
			_invalidGoogleTalkErrorMessage = invalidGoogleTalkErrorMessage;
		}
		
		override protected function doValidation(value : Object) : Array {
			var result : Array = super.doValidation(value);
			var string : String = Objects.castToString(value);
			
			if (result.length == 0 && !(Strings.isBlank(string) && !required)) {
				if (string.indexOf(GOOGLE_TALK_ACCOUNT_DOMAIN) == -1) {
					var validationResult : ValidationResult =
						new ValidationResult(true,
							null,
							INVALID_GOOGLE_TALK_ERROR_CODE,
							invalidGoogleTalkErrorMessage);
					result.push(validationResult);
				}
			}
			
			return result;
		}
		
		private var _invalidGoogleTalkErrorMessage : String = INVALID_GOOGLE_TALK_ERROR_MESSAGE;
		
	}

}