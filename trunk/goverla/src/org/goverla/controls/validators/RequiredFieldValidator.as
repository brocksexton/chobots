package org.goverla.controls.validators {
	
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;
	
	import mx.utils.StringUtil;
	
	/**
	 * Makes the associated input control a required field.
	 * 
	 * @author Tyutyunnyk Eugene
	 */
	public class RequiredFieldValidator extends BaseValidator {
		
		private var _initialValue : Object;
		
		/**
		 * Gets the initial value of the associated input control. 
		 */
		public function get initialValue() : Object {
			return _initialValue;
		}
		
		/**
		 * Sets the initial value of the associated input control. 
		 */
		public function set initialValue(value : Object) : void {
			_initialValue = value;
		}
		
		public function RequiredFieldValidator() {
			super();
		}
		
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.FIELD_REQUIRED;
			}
		}	
		
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean;
			var validationValue : Object = getControlValidationValue(controlToValidate);
			
			if (validationValue != null && validationValue != _initialValue) {
				if (validationValue is String) {
					result = !Strings.isBlank(StringUtil.trim(String(validationValue)));
				} else {
					result = true;
				}
			} else {
				result = false;
			}
			
			return result;
		}
	
	}
}