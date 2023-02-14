package org.goverla.events {
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class ResizeableLayoutEvent extends MouseEvent {
		
		public static const START_RESIZE : String = "startResize";
		
		public static const END_RESIZE : String = "endResize";

		public static const OPEN : String = "open";
		
		public static const CLOSE : String = "close";
		
		public static const RESIZE_MOUSE_OUT : String = "resizeMouseOut";
		
		public static const RESIZE_MOUSE_OVER : String = "resizeMouseOver";
		
		public function ResizeableLayoutEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, 
				localX : Number = NaN, localY : Number = NaN, relatedObject : InteractiveObject = null, 
				ctrlKey : Boolean = false, altKey : Boolean = false, shiftKey : Boolean = false, 
				buttonDown : Boolean = false, delta : int = 0) {
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
		
	}
	
}