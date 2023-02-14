package org.goverla.controls.editable.validators {
	
	import mx.validators.PhoneNumberValidator;
	import mx.validators.ValidationResult;

	public class ExtendedPhoneNumberValidator extends PhoneNumberValidator {
		
		protected override function doValidation(value : Object) : Array {
			var results : Array = super.doValidation(value);
			var actualValidationResults : Array = [];
			
			for each (var result : ValidationResult in results) {
				if (result.errorCode != "wrongLength") {
					actualValidationResults.push(result);
				}
			}
			return actualValidationResults;
		}
	}
}