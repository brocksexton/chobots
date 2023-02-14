package org.goverla.events {
	
	import flash.events.Event;

	public class CommandHistoryChangeEvent extends Event {
		
		public static const COMMAND_HISTORY_CHANGE : String = "commandHistoryChange";
		
		public function CommandHistoryChangeEvent() {
			super(COMMAND_HISTORY_CHANGE);
		}
		
	}
	
}