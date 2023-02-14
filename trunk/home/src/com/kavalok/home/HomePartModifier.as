package com.kavalok.home
{
	import com.kavalok.Global;
	import com.kavalok.dto.home.CharHomeTO;
	import com.kavalok.location.modifiers.IClipModifier;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.MovieClip;

	public class HomePartModifier implements IClipModifier
	{
		private static const CONFIG_ID : String = "homeConfig";
		
		private var _home : CharHomeTO;
		
		public function HomePartModifier(home : CharHomeTO)
		{
			_home = home;
		}

		public function accept(clip:MovieClip):Boolean
		{
			return GraphUtils.hasParameters(clip, CONFIG_ID);
		}
		
		public function modify(clip:MovieClip):void
		{
			var config : Object = GraphUtils.getParameters(clip, CONFIG_ID);
			
			if ('robot' in config && !_home.robotExists)
			{
				clip.parent.removeChild(clip);
				return;
			}
			/*
			if(!_home.citizen && config.show && config.show!="shower")
			{
				clip.parent.removeChild(clip);
				return;
			}
			
			if(_home.citizen && config.hide && Arrays.containsByRequirement(_home.items, new PropertyCompareRequirement("fileName", config.hide)))*/
			if(config.hide && Arrays.containsByRequirement(_home.items, new PropertyCompareRequirement("fileName", config.hide)))
			{
				clip.parent.removeChild(clip);
			} 
			else if(hasToShow(config.show))
			{
				clip.visible = true;
			}
			else
			{
				clip.parent.removeChild(clip);
//				clip.visible = false;
			}
		}
		
		private function hasToShow(show : String) : Boolean
		{
			if(show == null)
				return true;
			var parts : Array = show.split(",");
			for each(var part : String in parts)
			{
				if(!Arrays.containsByRequirement(_home.items,
					new PropertyCompareRequirement("fileName", part)))
				{
					return false;
				}
			}
			return true;
		} 
		
	}
}