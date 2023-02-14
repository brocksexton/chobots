package com.kavalok.char.modifiers
{
	import com.kavalok.char.LocationChar;
	
	
	public class MoonwalkModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		static private const SPEED:Number = 1;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.moonwalkMode = true;
			_char.speed = SPEED;
		}
		
		override protected function restore():void
		{
			_char.moonwalkMode = false;
			_char.speed = LocationChar.DEFAULT_SPEED;
		}

	}
}