package com.kavalok.char.modifiers
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	
	public class ToxicYellow extends CharModifierBase
	{
		static private const TIMEOUT:int = 30;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.model.filters = [
				new GlowFilter(0xFFFF00, 0.7, 10, 10, 1),
				new GlowFilter(0xFFFF00, 1, 10, 10, 1.2, 1, true),
			];
			
			var transform:ColorTransform = new ColorTransform(1, 1, 1, 1, 100, 100, 0);
			_char.model.transform.colorTransform = transform;
		}
		
		override protected function restore():void
		{
			_char.model.filters = [];
			_char.model.transform.colorTransform = new ColorTransform();
		}

	}
}