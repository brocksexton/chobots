package com.kavalok.char.modifiers
{
	import flash.display.BlendMode;
	
	public class BlendModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.content.blendMode = BlendMode.OVERLAY;
		}
		
		override protected function restore():void
		{
			_char.content.blendMode = BlendMode.NORMAL;
		}

	}
}