package com.kavalok.location.modifiers
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;

	public class PalmModifier implements IClipModifier
	{
		public function PalmModifier()
		{
		}

		public function accept(clip:MovieClip):Boolean
		{
			return clip.name == "palm";
		}
		
		public function modify(clip:MovieClip):void
		{
			GraphUtils.removeChildren(clip.leafs);
			clip.target.visible = false;
			clip.background.alpha = 0;
		}
		
	}
}