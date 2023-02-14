package org.goverla.controls.validators {
	
	import mx.utils.StringUtil;
	
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.utils.Strings;
	import org.goverla.utils.comparing.ComparingResult;
	import org.goverla.utils.comparing.NumberComparer;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class StringValidator extends BaseValidator {
		
		private var _minimumLength : Number;
		
		private var _maximumLength : Number;
		
		/**
		 * Gets minimum length of the validation string. Default value is 0.
		 */
		public function get minimumLength() : Number {
			return _minimumLength;
		}
	
		/**
		 * Sets minimum length of the validation string. Default value is 0.
		 */
		public function set minimumLength(value : Number) : void {
			_minimumLength = value;
		}
		
		/**
		 * Gets maximum length of the validation string. Default value is MAX_VALUE.
		 */
		public function get maximumLength() : Number {
			return _maximumLength;
		}
	
		/**
		 * Sets maximum length of the validation string. Default value is MAX_VALUE.
		 */
		public function set maximumLength(value : Number) : void {
			_maximumLength = value;
		}	
		
		public function StringValidator() {
			super();
			_minimumLength = 0;
			_maximumLength = Number.MAX_VALUE;
		}
		
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.FIELD_IS_INVALID_STRING;
			}
		}
		
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean = false;
			
			result = isControlValidationValueNull(controlToValidate);
			
			if (!result) {
				var validationValue : Object = getControlValidationValue(controlToValidate);
				if (validationValue is String) {
					var currentLength : Number = String(validationValue).length;
					result = (currentLength >= minimumLength) && (currentLength <= maximumLength); 
				}
			} else {
				result = (minimumLength == 0);
			}
			
			return result;
		}
		
		protected override function controlPropertiesValid() : Boolean {
			if (!(maximumLength is Number)) {
				throw new Error(StringUtil.substitute("The value '{0}' of the {1} property of '{2}' must be Number datatype.", maximumLength, "MaximumLength", id));
			}
	      
			if (!(minimumLength is Number)) {
				throw new Error(StringUtil.substitute("The value '{0}' of the {1} property of '{2}' must be Number datatype.", minimumLength, "MinimumLength", id));
			}
	      
			if (new NumberComparer().compare(minimumLength, maximumLength) == ComparingResult.GREATER) {
				throw new Error(StringUtil.substitute("The MaximumLength {0} cannot be less than the MinimumLength {1} of {2}.", maximumLength, minimumLength, id));
			}
	
			return super.controlPropertiesValid();
		}	
	
	}
}