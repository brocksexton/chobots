package org.goverla.events {

	import flash.events.Event;

	public class SaveOrCancelBoxEvent extends Event {
		
		public static const SAVE : String = "save";
		
		public static const CANCEL : String = "cancel";

		public function SaveOrCancelBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}

}