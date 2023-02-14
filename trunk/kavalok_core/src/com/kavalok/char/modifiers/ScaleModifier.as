package com.kavalok.char.modifiers
{
	import com.kavalok.Global;
	
	public class ScaleModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 120;
		static private const SCALE:Number = 0.6;
		
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