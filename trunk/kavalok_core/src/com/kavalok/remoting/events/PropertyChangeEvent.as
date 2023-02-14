package com.kavalok.remoting.events
{
	import com.kavalok.events.PropertyValueChangeEvent;

	public class PropertyChangeEvent extends PropertyValueChangeEvent
	{
		private static const PROPERTY_CHANGE : String = "propertyChange";
		
		private var _name : String;
		
		public function PropertyChangeEvent(name : String, newValue:Object, oldValue:Object = null)
		{
			super(PROPERTY_CHANGE, newValue, oldValue, false, false);
			_name = name;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
	}
}