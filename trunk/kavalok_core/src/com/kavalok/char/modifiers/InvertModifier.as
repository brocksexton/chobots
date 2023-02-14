package com.kavalok.char.modifiers
{
	import flash.display.BlendMode;
	
	public class InvertModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 20;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.model.blendMode = BlendMode.INVERT;
		}
		
		override protected function restore():void
		{
			_char.model.blendMode = BlendMode.NORMAL;
		}

	}
}