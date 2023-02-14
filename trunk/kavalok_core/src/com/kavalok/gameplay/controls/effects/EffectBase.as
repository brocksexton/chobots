package com.kavalok.gameplay.controls.effects
{
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.events.EventSender;
	
	import flash.display.DisplayObject;

	public class EffectBase implements IEffect
	{
		private var _finishEvent : EventSender = new EventSender();
		
		public function EffectBase()
		{
		}

		public function get finishEvent():EventSender
		{
			return _finishEvent;
		}

		public function play(object:DisplayObject):void
		{
			throw new NotImplementedError("abstract method");
		}
		
	}
}