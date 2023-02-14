package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.location.LocationBase;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class LocationColorModifier extends StuffCommandBase
	{
		public var color:int;
		
		override public function apply():void
		{
			Global.locationManager.locationChange.addListener(setColor);
			if (Global.locationManager.locationExists)
				setColor();
		}
		
		private function setColor():void
		{
			var r:Number = parseFloat(parameters.r) / 100;
			var g:Number = parseFloat(parameters.g) / 100;
			var b:Number = parseFloat(parameters.b) / 100;
			content.transform.colorTransform =	new ColorTransform(r, g, b);
		}
		
		override public function restore():void
		{
			Global.locationManager.locationChange.removeListener(setColor);
			content.transform.colorTransform = new ColorTransform();
		}
		
		public function get content():Sprite
		{
			 return MovieClip(location.content).background as Sprite;
		}
		
		private function get location():LocationBase
		{
			 return Global.locationManager.location;
		}
		
	}
}