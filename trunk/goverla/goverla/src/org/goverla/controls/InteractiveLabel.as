package org.goverla.controls {
	
	import flash.events.MouseEvent;
	
	import mx.controls.Label;

	public class InteractiveLabel extends Label {
		
		public function InteractiveLabel() {
			super();
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event : MouseEvent) : void {
			if (!enabled) {
				event.stopImmediatePropagation();
			}
		}
		
	}
	
}