package com.kavalok.char.modifiers
{
	import flash.utils.setTimeout;
	
	public class Scale4Modifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 30;
		static private const SCALE:Number = 4;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.scale = SCALE;
		}
		
		override protected function restore():void
		{
			_char.scale = 1;
		}

	}
}