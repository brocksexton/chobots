package org.goverla.events {

	import flash.events.Event;

	public class RemoteValidationResultEvent extends Event {

		public static const REMOTE_VALIDATION_VALID : String = "remoteValidationValid";
		
		public static const REMOTE_VALIDATION_INVALID : String = "remoteValidationInvalid";
		
		public function RemoteValidationResultEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}

}