package org.goverla.flash.process.events {
	
	import flash.events.Event;

	public class ThreadProcessEvent extends Event {
		
		public static const THREAD_PROCESS : String = "threadProcess";
		
		public function ThreadProcessEvent() {
			super(THREAD_PROCESS);
		}
		
	}
	
}