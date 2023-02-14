package com.kavalok.location.modifiers
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.ColorTransform;
	
	import gs.TweenLite;

	public class CharAlphaModifier extends LocationModifierBase
	{
		public function CharAlphaModifier()
		{
			super();
		}
		
		override public function apply():void
		{
			location.charAlphaNum = alpha;
		}
		
		override public function restore():void
		{
			location.charAlphaNum = 1;
		}
		
		public function get alpha():Number { return parameters.alpha; }
	}
}