package org.goverla.controls.validators {
	
	import org.goverla.constants.CreditCardNames;
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.events.CreditCardTypeChangedEvent;
	import org.goverla.utils.Strings;

	/**
	 * The CreditCardValidator class validates that a credit card number is 
	 * the correct length, has the correct prefix and passes the Luhn mod10 algorithm for the specified card type. 
	 * This validator does not check whether the credit card is an actual active credit card account.
	 * @author Tyutyunnyk Eugene
	 */
	public class CreditCardValidator extends RegularExpressionValidator {
		
		/**
		 * Luhn mod10 algorithm testing of the credit card number.
		 */
		public static function testLuhn(digitsOnlyCardNumber : String) : Boolean {
			var doubledigit : Boolean = false;
			var checkdigit : Number = 0;
			var tempdigit : Number;
			var cardNumLen : Number = digitsOnlyCardNumber.length;
			
			for (var i : Number = cardNumLen - 1; i >= 0; i--) {
				tempdigit = Number(digitsOnlyCardNumber.charAt(i));
				if (doubledigit) {
					tempdigit *= 2;
					checkdigit += (tempdigit % 10);
	
					if ((tempdigit / 10) >= 1.0) {
						checkdigit++;
					}
	
					doubledigit = false;
				} else {
					checkdigit = checkdigit + tempdigit;
					doubledigit = true;
				}
			}
	
			if ((checkdigit % 10) != 0) {
				return false;
			}
			
			return true;		
		}	
		
		private var _allowedFormatChars : String;
		
		private var _cardType : String;
		
		/**
		 * Gets the set of formatting characters allowed. 
		 * The default value is " -" (space and dash).
		 */
		public function get allowedFormatChars() : String {
			return _allowedFormatChars;
		}
	
		/**
		 * Sets the set of formatting characters allowed. 
		 * The default value is " -" (space and dash).
		 */	
		public function set allowedFormatChars(chars : String) : void {
			_allowedFormatChars = chars;
		}
		
		/**
		 * Gets the credit card type.
		 */
		[ChangeEvent("cardTypeChanged")]
		public function get cardType() : String {
			return _cardType;
		}
		
		/**
		 * Sets the credit card type. 
		 */
		public function set cardType(type : String) : void {
			trace("CreditCardValidator: set cardType = " + type);
			if (CreditCardNames.isCreditCardName(type)) {
				_cardType = type;
				setCreditCardRegularExp();
				dispatchEvent(new CreditCardTypeChangedEvent());
			} else {
				if (isCreationComplete) {
					throw new IllegalArgumentError("The credit card type value is invalid! Please set the value from CreditCardType enumerations.");
				}
			}
		}
		
		public function CreditCardValidator() {
			super();
			
			_allowedFormatChars = " -";
			validationExpression = "";
		}
		
		protected override function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.CARD_IS_INVALID;
			}
		}
		
		private function setCreditCardRegularExp() : void {
			switch (_cardType) {
				case CreditCardNames.MASTER_CARD:
					validationExpression = "5[1-5][0-9]{14}";
					break;
					
				case CreditCardNames.VISA:
					validationExpression = "4[0-9]{12}([0-9]{3})?"; 
					break;
	
				case CreditCardNames.AMERICAN_EXPRESS:
					validationExpression = "(34|47)[0-9]{13}"; 
					break;
	
				case CreditCardNames.DISCOVER:
					validationExpression = "6011[0-9]{12}";
					break;
	
				case CreditCardNames.DINERS_CLUB:
					validationExpression = "3(0[0-5]|6|8)[0-9]{11,12}"; 
					break;
			}
		}
		
		protected override function getControlValidationValue(name : String, propertyName : String = null) : Object {
			var result : String = String(super.getControlValidationValue(name, propertyName));
			result = Strings.removeSymbols(result, _allowedFormatChars);
			return result;
		}
		
		protected override function evaluateIsValid() : Boolean {
			var result : Boolean = super.evaluateIsValid();
			if (result) {
				var digitsOnlyCardNum : String = String(getControlValidationValue(controlToValidate));
				return CreditCardValidator.testLuhn(digitsOnlyCardNum);
			}
	
			return false;
		}
	
	}
}