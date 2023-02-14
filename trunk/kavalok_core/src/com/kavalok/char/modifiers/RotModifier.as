package com.kavalok.char.modifiers
{
	import flash.events.Event;
	
	public class RotModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		static private const PERIOD:int = 10;
		static private const MAGNITUDE:int = 20;
		private var _counter:int = 0;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.content.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override protected function restore():void
		{
			_char.content.removeEventListener(Event.ENTER_FRAME, onFrame);
			_char.content.rotation = 0;
		}
		
		private function onFrame(e:Event):void
		{
			_counter++;
			_char.content.rotation = Math.sin(_counter / PERIOD) / Math.PI * MAGNITUDE;
		}

	}
}