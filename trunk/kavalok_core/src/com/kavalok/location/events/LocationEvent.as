package com.kavalok.location.events
{
	import com.kavalok.events.DefaultEvent;

	public class LocationEvent extends DefaultEvent
	{
		private var _locationId : String;
		
		public function LocationEvent(locationId : String)
		{
			super();
			_locationId = locationId;
		}
		
		public function get locationId() : String
		{
			return _locationId;
		}
		
	}
}