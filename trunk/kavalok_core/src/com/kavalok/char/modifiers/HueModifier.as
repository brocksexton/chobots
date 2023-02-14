package com.kavalok.char.modifiers
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	public class HueModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		static private const SPEED:int = 5;
		
		private var _hueValue:int = 0;
		private var _hueStep:int = SPEED;
		
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
			_hueValue += _hueStep;
			
			if (_hueValue >= 100 || _hueValue <= -100)
				_hueStep = -_hueStep;
			
			var matrix:ColorMatrix = new ColorMatrix();
			matrix.adjustHue(_hueValue);
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			_char.model.filters = [filter];
		}
		
		override protected function restore():void
		{
			_char.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_char.model.filters = [];
		}

	}
}