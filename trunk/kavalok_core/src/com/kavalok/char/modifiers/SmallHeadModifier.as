package com.kavalok.char.modifiers
{
	import flash.utils.setTimeout;
	
	public class SmallHeadModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 120;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.headScale = 0.7;
			_char.scale = 1.2;
		}
		
		override protected function restore():void
		{
			_char.headScale = 1;
			_char.scale = 1;
		}

	}
}