package org.goverla.events {

	import flash.events.Event;

	public class FormDataProviderEvent extends Event {
		
		public static const REFRESH : String = "formDataProviderRefresh";
		
		public static const SAVE : String = "formDataProviderSave";
		
		public static const SAVE_FAULT : String = "formDataProviderSaveFault";
		
		public function FormDataProviderEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event {
			return new FormDataProviderEvent(type, bubbles, cancelable);
		}
		
	}

}