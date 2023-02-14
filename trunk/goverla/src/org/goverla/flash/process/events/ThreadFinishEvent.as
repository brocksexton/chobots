package org.goverla.flash.process.events {
	
	import flash.events.Event;

	public class ThreadFinishEvent extends Event {
		
		public static const THREAD_FINISH : String = "threadFinish";

		public function ThreadFinishEvent() {
			super(THREAD_FINISH);
		}
		
	}
	
}