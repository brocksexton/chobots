package com.kavalok.char.modifiers
{
	import flash.utils.setTimeout;
	
	public class SpeedModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		static private const MULTIPLIER:int = 4;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.speed *= MULTIPLIER;
		}
		
		override protected function restore():void
		{
			_char.speed /= MULTIPLIER;
		}

	}
}