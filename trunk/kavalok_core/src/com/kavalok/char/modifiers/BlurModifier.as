package com.kavalok.char.modifiers
{
	import flash.filters.BlurFilter;
	
	public class BlurModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		static private const ALPHA:Number = 0.5;
		static private const FILTERS:Array = [new BlurFilter(10, 10)];
		
		override public function get timeout():int
		{
			return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.content.alpha = ALPHA;
			_char.content.filters = FILTERS;
		}
		
		override protected function restore():void
		{
			_char.content.alpha = 1
			_char.content.filters = [];
		}
	}
}