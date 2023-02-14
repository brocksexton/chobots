package com.kavalok.char.modifiers
{
	import flash.events.Event;
	
	public class GhostModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_char.model.visible = false;
		}
		
		override protected function restore():void
		{
			_char.model.visible = true;
			_char.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

	}
}