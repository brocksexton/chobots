package org.goverla.controls.editable.validators {
	
	import mx.validators.EmailValidator;
	import mx.validators.ValidationResult;
	
	import org.goverla.utils.Objects;
	
	public class StrictEmailValidator extends EmailValidator {
		
		protected override function doValidation(value : Object) : Array {
			var results : Array = super.doValidation(value);
			var validatedValue : String = (value != null ? Objects.castToString(value) : "");
			
			if (results.length == 0 && (validatedValue.length != 0 || required)) {
				if (validatedValue.search(/\.\./) != -1) {
					results.push(new ValidationResult(true, null, "dotsInARow", "Dots cannot be in a row"));
				}
				// if EmailValidator doesn't return errors then there should be @-symbol
				var atIndex : int = validatedValue.indexOf("@");
				// check username part if its length is not more than 20 symbols
				if (atIndex > 20) {
					results.push(new ValidationResult(true, null, "usernameTooLong", "The username in your e-mail address is too long (20 symbols maximum)"));
				}
				// check domain part if its length is not more than 29 symbols
				if (validatedValue.length - atIndex > 30) {
					results.push(new ValidationResult(true, null, "domainTooLong", "The domain in your e-mail address is too long (29 symbols maximum)"));
				}
			}
			
			return results;
		}
		
	}
}