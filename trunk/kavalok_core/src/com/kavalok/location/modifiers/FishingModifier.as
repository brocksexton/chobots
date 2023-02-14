package com.kavalok.location.modifiers
{
	
	import flash.display.MovieClip;
	
	public class FishingModifier implements IClipModifier
	{
		
		
		public function FishingModifier()
		{
			
		}
		
		public function accept(clip:MovieClip):Boolean
		{
			trace("isFish clip: " + clip.name == "fishing");
			return clip.name == "fishing"; // if this mc is "fishing", then it is a fishing location
		}
		
		public function modify(clip:MovieClip):void
		{
			//TODO: implement function
			// nothing to do..
			clip.alpha = 0;
			clip.visible = true;
			//clip.target.visible = true;
		}
	}
}