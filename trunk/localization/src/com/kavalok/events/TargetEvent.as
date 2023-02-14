package com.kavalok.events
{
	import flash.events.Event;

	public class TargetEvent extends Event
	{
		private var _target : Object;
		
		public function TargetEvent(target : Object, type : String = "")
		{
			super(type);
			_target = target;
		}
		
		override public function get target() : Object
		{
			return _target;
		}
		
	}
}