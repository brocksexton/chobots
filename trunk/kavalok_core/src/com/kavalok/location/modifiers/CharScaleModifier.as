package com.kavalok.location.modifiers
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.ColorTransform;
	
	import gs.TweenLite;

	public class CharScaleModifier extends LocationModifierBase
	{
		public function CharScaleModifier()
		{
			super();
		}
		
		override public function apply():void
		{
			location.predefinedCharsScale = scale;
		}
		
		override public function restore():void
		{
			location.predefinedCharsScale = Number.MIN_VALUE;
		}
		
		public function get scale():Number { return parameters.scale; }
	}
}