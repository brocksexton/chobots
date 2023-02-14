package org.goverla.events
{
	import flash.events.Event;

	public class PropertyValueChangeEvent extends Event
	{
		private var _oldValue : Object;
		private var _newValue : Object;
		
		public function PropertyValueChangeEvent(type:String, newValue : Object, oldValue : Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		public function get oldValue() : Object {
			return _oldValue;
		}
		
		public function get newValue() : Object {
			return _newValue;
		}
		
	}
}