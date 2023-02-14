package org.goverla.events {

	import flash.events.Event;

	public class CollapsablePanelEvent extends Event {
		
		public static const STATE_CHANGE : String = "stateChange";
		
		public function CollapsablePanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}

}