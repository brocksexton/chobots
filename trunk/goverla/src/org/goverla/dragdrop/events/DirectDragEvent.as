package org.goverla.dragdrop.events
{
	import mx.events.DragEvent;
	import mx.core.DragSource;
	import mx.core.IUIComponent;

	public class DirectDragEvent extends DragEvent {

		public static const SELECT_SOURCE : String = "selectSource";
		public static const SELECT_TARGET : String = "selectTarget";
		
		public function DirectDragEvent(type:String) {
			super(type);
		}
		
	}
}