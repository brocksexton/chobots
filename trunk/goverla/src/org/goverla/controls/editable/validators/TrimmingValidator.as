package org.goverla.controls.editable.validators {

	import mx.utils.StringUtil;
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;

	public class TrimmingValidator extends StringValidator {
		
		protected static const TRIMMING_ERROR_CODE : String = "requiredField";
		
		protected static const TRIMMING_ERROR_MESSAGE : String = "This field is required.";

		public function TrimmingValidator() {
			super();
		}
		
		public function get trimmingErrorMessage() : String {
			return _trimmingErrorMessage;
		}
		
		public function set trimmingErrorMessage(trimmingErrorMessage : String) : void {
			_trimmingErrorMessage = trimmingErrorMessage;
		}
		
		override protected function doValidation(value : Object) : Array {
			var result : Array = super.doValidation(value);
			
			if (result.length == 0) {
				var string : String = Objects.castToString(value);
				var trimmed : String = StringUtil.trim(string);
				if (required && Strings.isBlank(trimmed)) {
					var validationResult : ValidationResult =
						new ValidationResult(true,
							null,
							TRIMMING_ERROR_CODE,
							trimmingErrorMessage);
					result.push(validationResult);
				}
			}
			
			return result;
		}
		
		private var _trimmingErrorMessage : String = TRIMMING_ERROR_MESSAGE;
		
	}

}