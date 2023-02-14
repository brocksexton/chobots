package org.goverla.controls.editable.validators {

	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	import org.goverla.utils.Objects;

	public class TagsValidator extends Validator {
		
		protected static const INVALID_TAGS_ERROR_CODE : String = "invalidTagsErrorCode";
		
		protected static const INVALID_TAGS_ERROR_MESSAGE_TEMPLATE : String = "Enter valid tags (each tag length should not be greater than {0} characters)";

		public function TagsValidator() {
			super();
		}
		
		public function get tagMaxChars() : int {
			return _tagMaxChars;
		}
		
		public function set tagMaxChars(tagMaxChars : int) : void {
			_tagMaxChars = tagMaxChars;
		}
		
		private function get invalidTagErrorMessage() : String {
			return StringUtil.substitute(INVALID_TAGS_ERROR_MESSAGE_TEMPLATE, _tagMaxChars);
		} 
		
		override protected function doValidation(value : Object) : Array {
			var result : Array = super.doValidation(value);
			
			if (result.length == 0) {
				var valid : Boolean = true;
				var string : String = Objects.castToString(value);
				var tags : Array = string.split(",");
				for (var i : int = 0; i < tags.length; i++) {
					var tag : String = StringUtil.trim(tags[i]);
					valid = (valid && tag.length <= _tagMaxChars);
				}
				if (!valid) {
					var validationResult : ValidationResult =
						new ValidationResult(true,
							null,
							INVALID_TAGS_ERROR_CODE,
							invalidTagErrorMessage);
					result.push(validationResult);
				}
			}
			
			return result;
		}
		
		private var _tagMaxChars : int = 50;
		
	}

}