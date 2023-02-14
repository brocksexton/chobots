package org.goverla.controls.validators {

	import org.goverla.controls.validators.common.ConvertedResult;
	import org.goverla.controls.validators.common.ValidationCompareOperator;
	import org.goverla.controls.validators.common.ValidationDataType;
	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.utils.Objects;
	import org.goverla.utils.comparing.DateComparer;
	import org.goverla.utils.comparing.NumberComparer;
	import org.goverla.utils.comparing.StringComparer;
	
	/**
	 * Serves as the abstract base class for validation controls that perform typed comparisons.
	 * @author Tyutyunnyk Eugene
	 */
	internal class BaseCompareValidator extends BaseValidator {
		
		/**
		 * Determines whether the specified string can be converted to the specified data type.
		 * @param value The string or the object to test.
		 * @param type One of the ValidationDataType values.
		 * @return true if the specified data string can be converted to the specified data type; otherwise, false.
		 */
		public static function canConvert(value : Object, type : String) : Boolean {
			var convertedResult : ConvertedResult = BaseCompareValidator.convert(value, type);
			return convertedResult.isConvertable;
		}
		
		/**
		 * Compares two strings or objects using the specified operator and validation data type.
		 * @param leftValue The value on the left side of the operator.
		 * @param rightValue The value on the right side of the operator.
		 * @param operator One of the ValidationCompareOperator values.
		 * @param type One of the ValidationDataType values. 
		 */
		protected static function compare(leftValue : Object, rightValue : Object, operator : String, type : String) : Boolean {
			var result : Boolean = false;
			
			var leftConvertedResult : ConvertedResult = BaseCompareValidator.convert(leftValue, type);
			if (leftConvertedResult.isConvertable) {
				if (operator != ValidationCompareOperator.DATA_TYPE_CHECK)
				{
					var rightConvertedResult : ConvertedResult = BaseCompareValidator.convert(rightValue, type);
					if (!rightConvertedResult.isConvertable) {
						result = true;
					} else {
						var delta : Number = 0;
						
						switch (type.toLowerCase()) {
							case ValidationDataType.STRING:
								delta = new StringComparer().compare(String(leftConvertedResult.convertedValue), 
									String(rightConvertedResult.convertedValue));
								break;
								
							case ValidationDataType.INTEGER:
							 	delta = new NumberComparer().compare(int(leftConvertedResult.convertedValue), 
									int(rightConvertedResult.convertedValue));
								break;
								
							case ValidationDataType.REAL:
							 	delta = new NumberComparer().compare(Number(leftConvertedResult.convertedValue), 
									Number(rightConvertedResult.convertedValue));
								break;
	
							case ValidationDataType.DATE:
							 	delta = new DateComparer().compare(Objects.castToDate(leftConvertedResult.convertedValue), 
									Objects.castToDate(rightConvertedResult.convertedValue));
								break;
						}
						
						switch (operator.toLowerCase()) {
							case ValidationCompareOperator.EQUAL:
	                  			result = (delta == 0);
	                  			break;
	
							case ValidationCompareOperator.NOT_EQUAL:
	                  			result = (delta != 0);
	                  			break;
	
							case ValidationCompareOperator.GREATER_THAN:
								result = (delta > 0);
								break;
	
							case ValidationCompareOperator.GREATER_THAN_EQUAL:
								result = (delta >= 0);
								break;
	
							case ValidationCompareOperator.LESS_THAN:
								result = (delta < 0);
								break;
	
							case ValidationCompareOperator.LESS_THAN_EQUAL:
								result = (delta <= 0);
								break;
								
							default:
								result = true;
								break;
						}
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Converts the specified text into an object of the specified data type.
		 * @param value The text to convert or object to return.
		 * @param One of the ValidationDataType values.
		 * @return The instance of ConvertedResult with convertion availability parameters.
		 */
		protected static function convert(value : Object, type : String) : ConvertedResult {
			var result : ConvertedResult = new ConvertedResult();
			
			if (value is String) {
				switch (type.toLowerCase()) {
					case ValidationDataType.STRING:
						result.convertedValue = String(value);
						break;
						
					case ValidationDataType.INTEGER:
						result.convertedValue = parseInt(String(value));
						if (isNaN(Number(result.convertedValue))) {
							result.convertedValue = null;
						}
						break;
						
					case ValidationDataType.REAL:
						result.convertedValue = parseFloat(String(value));
						if (isNaN(Number(result.convertedValue))) {
							result.convertedValue = null;
						}
						break;
						
					case ValidationDataType.DATE:
						result.convertedValue = new Date(Date.parse(String(value)));
						break;
				}
			} else {
				result.convertedValue = value;
			}
			
			result.isConvertable = result.convertedValue != null || value == null;
			return result;
		}
		
		private var _type : String;
		
		/**
		 * Gets the data type that the values being compared are converted to before the comparison is made.
		 * Default value is STRING.
		 */
		public function get type() : String {
			return _type;
		}
		
		/**
		 * Sets the data type that the values being compared are converted to before the comparison is made. 
		 * Default value is STRING.
		 */
		public function set type(value : String) : void {
			if (ValidationDataType.isValidationDataType(value)) {
				_type = value.toLowerCase();
			} else {
				throw new IllegalArgumentError("The type value is invalid! Please set the value from ValidationDataType constants.");
			}
		}
		
		public function BaseCompareValidator() {
			super();
			_type = ValidationDataType.STRING;
		}
	
	}
}