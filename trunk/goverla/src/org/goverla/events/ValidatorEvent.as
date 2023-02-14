package org.goverla.events {

	import flash.events.Event;

	public class ValidatorEvent extends Event {

		public static const IS_VALID_CHANGE : String = "isValidChange";
		
		public static const ENABLED_CHANGE : String = "enabledChange";
		
		public function ValidatorEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}

}