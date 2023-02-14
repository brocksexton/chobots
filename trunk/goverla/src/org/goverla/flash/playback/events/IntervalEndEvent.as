package org.goverla.flash.playback.events
{
	import flash.events.Event;

	public class IntervalEndEvent extends Event
	{
		public static const INTERVAL_END : String = "intervalEnd";
		
		public function IntervalEndEvent()
		{
			super(INTERVAL_END);
		}
		
	}
}