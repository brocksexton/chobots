package com.kavalok.char.modifiers
{
	import flash.utils.setTimeout;
	
	public class BigHeadModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 120;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.headScale = 1.5;
			_char.scale = 0.85;
		}
		
		override protected function restore():void
		{
			_char.headScale = 1;
			_char.headScale = 1;
		}

	}
}