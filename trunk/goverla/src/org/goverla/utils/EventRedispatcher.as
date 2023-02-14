package org.goverla.utils {

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class EventRedispatcher {
		
		private var _redispatcher : IEventDispatcher;
		
		public function EventRedispatcher(redispatcher : IEventDispatcher) {
			_redispatcher = redispatcher;
		}
		
		public function facadeEvents(dispatcher : IEventDispatcher, ...events) : void {
			for each (var event : String in events) {
				dispatcher.addEventListener(event, redispatch);
			}
		}
		
		private function redispatch(event : Event) : void {
			_redispatcher.dispatchEvent(event.clone());
		}
		
	}

}