package org.goverla.controls.editable.messenger {

	import mx.validators.Validator;

	public class MessengerProperties {
		
		private var _indicator : Object;
		
		private var _validator : Validator;
		
		public function MessengerProperties(indicator : Object, validator : Validator) {
			_indicator = indicator;
			_validator = validator;
		}
		
		public function get indicator() : Object {
			return _indicator;
		}
		
		public function get validator() : Validator {
			return _validator;
		}
		
	}

}