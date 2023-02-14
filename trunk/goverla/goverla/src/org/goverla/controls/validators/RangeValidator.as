package org.goverla.controls.validators {
	
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.controls.validators.common.ValidationCompareOperator;
	import org.goverla.utils.Strings;
	
	import mx.utils.StringUtil;
	
	/**
	 * Checks whether the value of an input control is within a specified range of values.
	 * @author Tyutyunnyk Eugene
	 */
	public class RangeValidator extends BaseCompareValidator {
		
		private var _minimumValue : Object;
		
		private var _maximumValue : Object;
		
		/**
		 * Gets minimum value of the validation range.
		 */
		public function get minimumValue() : Object {
			return _minimumValue;
		}
	
		/**
		 * Sets minimum value of the validation range.
		 */
		public function set minimumValue(value : Object) : void {
			_minimumValue = value;
		}
		
		/**
		 * Gets maximum value of the validation range.
		 */
		public function get maximumValue() : Object {
			return _maximumValue;
		}
	
		/**
		 * Sets maximum value of the validation range.
		 */
		public function set maximumValue(value : Object) : void {
			_maximumValue = value;
		}	
	
		public function RangeValidator() {
			super();
		}
		
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.FIELD_NOT_IN_RANGE;
			}
		}	
		
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean = false;
			
			result = isControlValidationValueNull(controlToValidate);
			
			if (!result) {
				var validationValue : Object = getControlValidationValue(controlToValidate);
	      		if (BaseCompareValidator.compare(validationValue, minimumValue, 
	      			ValidationCompareOperator.GREATER_THAN_EQUAL, type)) {
	            	return BaseCompareValidator.compare(validationValue, maximumValue, 
	            		ValidationCompareOperator.LESS_THAN_EQUAL, type);
	      		}
			}
			
			return result;
		}
	
		protected override function controlPropertiesValid() : Boolean {
			if (!BaseCompareValidator.canConvert(maximumValue, type)) {
				throw new Error(StringUtil.substitute("The value '{0}' of the {1} property of '{2}' cannot be converted to type '{3}'.", maximumValue, "MaximumValue", id, type));
			}
	      
			if (!BaseCompareValidator.canConvert(minimumValue, type)) {
				throw new Error(StringUtil.substitute("The value '{0}' of the {1} property of '{2}' cannot be converted to type '{3}'.", minimumValue, "MinimumValue", id, type));
			}
	      
			if (BaseCompareValidator.compare(minimumValue, maximumValue, ValidationCompareOperator.GREATER_THAN, type)) {
				throw new Error(StringUtil.substitute("The MaximumValue {0} cannot be less than the MinimumValue {1} of {2}.", maximumValue, minimumValue, id));
			}
	
			return super.controlPropertiesValid();
		}
	
	}
}