package com.kavalok.char.modifiers
{
	import flash.events.Event;
	import flash.filters.BevelFilter;
	
	public class BevelModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 20;
		
		static private const SPEED:int = 2;
		static private const COLOR:int = 0xFFFF00;
		static private const DISTANCE:int = 8;
		
		private var _bevelAngle:int = 0;
		
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
			_bevelAngle += SPEED;
			
			var filter:BevelFilter = new BevelFilter();
			filter.highlightColor = COLOR;
			filter.shadowColor = COLOR;
			filter.blurX = DISTANCE;
			filter.blurY = DISTANCE;
			filter.distance = DISTANCE;
			filter.strength = 0.9;
			filter.angle = _bevelAngle;
			
			_char.model.filters = [filter];
		}
		
		override protected function restore():void
		{
			_char.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_char.model.filters = [];
		}

	}
}