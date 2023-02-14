package org.goverla.controls.validators {

	import org.goverla.utils.Objects;
	
	/**
	 * Performs user-defined validation on an input control.  
	 * 
	 * @author Tyutyunnyk Eugene
	 */
	public class CustomValidator extends BaseValidator {
		
		/**
		 * Occurs when validation is performed on the user ActionScript side. 
		 */
		public var onValidate : Function;
		
		public function CustomValidator() {
			super();
		}
		
		protected override function controlPropertiesValid() : Boolean {
			var controlID : String = controlToValidate;
			if (controlID.length > 0) {
			    checkControlValidationProperty(controlID, "ControlToValidate");
			}
			
			return true;
		}
	
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean = false;
			var controlID : String = controlToValidate;
			
			if (controlID.length > 0) {
				result = isControlValidationValueNull(controlID);
			}
			
			if (!result) {
				if (Objects.isSet(onValidate)) {
					var validationValue : Object = getControlValidationValue(controlToValidate);
					result = Boolean(onValidate(validationValue));
				} else {
					result = true;
				}
			}
			
			return result;
		}
	
	}
}