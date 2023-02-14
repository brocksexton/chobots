package org.goverla.events
{
	import flash.events.Event;
	
	public class ChangeEvent extends TargetEvent
	{
		public static const CHANGE : String = "change";
		
		public function ChangeEvent(target:Object)
		{
			super(target, CHANGE);
		}
		
		override public function clone():Event
		{
			return new ChangeEvent(target);
		}
		
	}
}