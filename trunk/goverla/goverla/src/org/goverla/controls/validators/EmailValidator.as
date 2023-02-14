package org.goverla.controls.validators {
	
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.utils.Strings;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class EmailValidator extends RegularExpressionValidator {
		
		public function EmailValidator() {
			super();
			
			validationExpression = "[a-zA-Z0-9._%-]+@[a-zA-Z0-9-.]+\\.[a-zA-Z]{2,255}";
		}
		
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.EMAIL_IS_INVALID;
			}
		}
	
	}
}