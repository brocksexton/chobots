package com.kavalok.admin.messages.events
{
	import flash.events.Event;

	public class ProcessedEvent extends Event
	{
		public static const PROCESSED : String = "processed";
		
		public var id : int;
		
		public function ProcessedEvent(id : int)
		{
			super(PROCESSED, true);
			this.id = id;
		}
		
	}
}