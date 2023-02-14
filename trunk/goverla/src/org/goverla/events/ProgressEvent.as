package org.goverla.events {
	
	import flash.events.Event;
	
	import org.goverla.errors.IllegalArgumentError;

	public class ProgressEvent extends Event {
		
		public static const PROGRESS : String = "progress";
		
		public function ProgressEvent(progress : Number) {
			super(PROGRESS);
			if (progress < 0 && progress > 1) {
				throw new IllegalArgumentError("progress must be < 1 AND > 0");
			}
			_progress = progress;
		}
		
		public function get progress() : Number {
			return _progress;
		}
		
		private var _progress : Number;
		
	}
	
}