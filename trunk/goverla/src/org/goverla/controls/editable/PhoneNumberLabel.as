package org.goverla.controls.editable {
	
	import org.goverla.controls.editable.validators.ExtendedPhoneNumberValidator;

	public class PhoneNumberLabel extends TextInputLabel {
		
		public function PhoneNumberLabel() {
			super();
			
			restrict = "\\-+*. ()#0-9";
			
			var phoneNumberValidator : ExtendedPhoneNumberValidator = new ExtendedPhoneNumberValidator();
			phoneNumberValidator.allowedFormatChars = "-+*. ()#";
			validator = phoneNumberValidator;
		}
		
	}

}