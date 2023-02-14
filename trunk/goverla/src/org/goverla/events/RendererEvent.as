package org.goverla.events
{
	import flash.events.Event;

	public class RendererEvent extends Event
	{
		public static const DATA_CHANGE : String = "dataChange";

		public static const LIST_DATA_CHANGE : String = "listDataChange";

		public var oldValue : Object;

		public var newValue : Object;

		public function RendererEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}