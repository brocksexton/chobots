package com.kavalok.events
{
	import flash.events.Event;

	public class DefaultEvent extends Event
	{
		private static const DEFAULT : String = "default";
		
		public function DefaultEvent()
		{
			super(DEFAULT);
		}
		
	}
}