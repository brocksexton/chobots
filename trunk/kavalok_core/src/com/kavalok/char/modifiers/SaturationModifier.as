package com.kavalok.char.modifiers
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.filters.BevelFilter;
	import flash.filters.ColorMatrixFilter;
	
	public class SaturationModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		static private const MULTIPLIER:int = 4;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			var matrix:ColorMatrix = new ColorMatrix();
			matrix.adjustColor(15, 0, -90, 0);
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filter2:BevelFilter = new BevelFilter();
			filter2.strength = 0.8;
			
			_char.model.filters = [filter, filter2];
		}
		
		override protected function restore():void
		{
			_char.model.filters = [];
		}

	}
}