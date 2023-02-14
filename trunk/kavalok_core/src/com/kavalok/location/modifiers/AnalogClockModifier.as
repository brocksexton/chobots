package com.kavalok.location.modifiers
{
	import flash.display.Sprite;
	
	
	public class AnalogClockModifier extends ClockModifierBase
	{
		public static const PREFIX : String = "analogClock";
		
		public function AnalogClockModifier(content:Sprite)
		{
			super(content);
		}
		
		override protected function updateClock():void
		{
			minuteArrow.rotation = (minutes + seconds / 60.0) / 60.0 * 360;
			hourArrow.rotation = (hours % 12) / 12 * 360 + minutes / 60.0 * 30;
		}
		
		public function get minuteArrow():Sprite
		{
			 return content['minuteArrow'];
		}
		
		public function get hourArrow():Sprite
		{
			 return content['hourArrow'];
		}
	}
}