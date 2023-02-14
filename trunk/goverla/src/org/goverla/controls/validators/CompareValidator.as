package org.goverla.controls.validators {
	
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.controls.validators.common.UIControlsDefaultValidationProperty;
	import org.goverla.controls.validators.common.ValidationCompareOperator;
	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;
	
	/**
	 * Compares the value entered by the user into an input control with 
	 * the value entered into another input control or a constant value.
	 * @author Tyutyunnyk Eugene
	 */
	public class CompareValidator extends BaseCompareValidator {
		
		private var _controlToCompare : String;
		
		private var _comparePropertyToValidate : String;
		
		private var _operator : String;
		
		private var _valueToCompare : Object;
	
		/**
		 * Gets the input control to compare with the input control being validated. 
		 */
		public function get controlToCompare() : String {
			return _controlToCompare;
		}
		
		/**
		 * Sets the input control to compare with the input control being validated.  
		 */
		public function set controlToCompare(id : String) : void {
			_controlToCompare = id;
		}
		
		public function get comparePropertyToValidate() : String {
			if (!Objects.isSet(_comparePropertyToValidate) && Objects.isSet(_controlToCompare)) {
				_comparePropertyToValidate = UIControlsDefaultValidationProperty.getPropertyByControlInstance(document[_controlToCompare]);
			}
			
			return _comparePropertyToValidate;
		}
		
		public function set comparePropertyToValidate(id : String) : void {
			_comparePropertyToValidate = id;
		}
		
		/**
		 * Gets the comparison operation to perform. Default value is EQUAL.
		 */
		public function get operator() : String {
			return _operator;
		}
		
		/**
		 * Sets the comparison operation to perform. Default value is EQUAL. 
		 */
		public function set operator(value : String) : void {
			if (ValidationCompareOperator.isCompareOperator(value)) {
				_operator = value.toLowerCase();
			} else {
				throw new IllegalArgumentError("The operator value is invalid! Please set the value from ValidationCompareOperator constants.");
			}
		}
		
		/**
		 * Gets a constant value to compare with the value entered by the user into the input control being validated.
		 */
		public function get valueToCompare() : Object {
			return _valueToCompare;
		}
		
		/**
		 * Sets a constant value to compare with the value entered by the user into the input control being validated.
		 */
		public function set valueToCompare(value : Object) : void {
			_valueToCompare = value;
		}
		
		public function CompareValidator() {
			super();
			_operator = ValidationCompareOperator.EQUAL;
		}
		
		protected override function onCreationComplete(event : Object) : void {
			super.onCreationComplete(event);
			
			if (propertiesValid && controlToCompare != null) {
				appendEventListeners(UIComponent(document[controlToCompare]));
			}
		}	
		
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.FIELDS_NOT_EQUAL;
			}
		}	
		
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean = false;
			
			var compareValue : Object;
			if (controlToCompare != null && controlToCompare.length > 0) {
				compareValue = getControlValidationValue(controlToCompare, comparePropertyToValidate);
			}
			else {
				compareValue = valueToCompare;
			}
		
			var validationValue : Object = getControlValidationValue(controlToValidate);
			result = BaseCompareValidator.compare(validationValue, compareValue, operator, type);
			
			return result;
		}
	
		protected override function controlPropertiesValid() : Boolean {
			if (controlToCompare != null && controlToCompare.length > 0) {
				super.checkControlValidationProperty(controlToCompare, "ControlToCompare");
				if (controlToValidate == controlToCompare) {
					throw new Error(StringUtil.substitute("Control '{0}' cannot have the same value '{1}' for both ControlToValidate and ControlToCompare.", id, controlToCompare));
				}
			} else if ((operator != ValidationCompareOperator.DATA_TYPE_CHECK) && !BaseCompareValidator.canConvert(valueToCompare, type)) {
				throw new Error(StringUtil.substitute("The value '{0}' of the {1} property of '{2}' cannot be converted to type '{3}'.", valueToCompare, "ValueToCompare", id, type));
			}
	
			return super.controlPropertiesValid();
		}
		
	}
}