package org.goverla.controls.validators {

	import org.goverla.controls.validators.common.ConvertedResult;
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.controls.validators.common.ValidationDataType;
	import org.goverla.utils.Strings;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class NumberValidator extends BaseCompareValidator {
		
		public function NumberValidator() {
			super();
			type = ValidationDataType.INTEGER; 
		}
	
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.FIELD_IS_INVALID_NUMBER;
			}
		}
		
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean = false;
			
			result = isControlValidationValueNull(controlToValidate);
			
			if (!result) {
				var validationValue : Object = getControlValidationValue(controlToValidate);
				var convertedResult : ConvertedResult = convert(validationValue, type);
				if (convertedResult.isConvertable && (convertedResult.convertedValue is Number)) {
					result = true;
				}
			} else {
				result = true;
			}
			
			return result;
		}
		
	}
}