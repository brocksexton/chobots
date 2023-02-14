package com.kavalok.location.modifiers
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.ColorTransform;
	
	import gs.TweenLite;

	public class CharRotationModifier extends LocationModifierBase
	{
		public function CharRotationModifier()
		{
			super();
		}
		
		override public function apply():void
		{
			location.charRotationNum = rotation;
		}
		
		override public function restore():void
		{
			location.charRotationNum = 0;
		}
		
		public function get rotation():Number { return parameters.rotation; }
	}
}