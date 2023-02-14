package com.kavalok.home.modifiers
{
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.LocationEntryPoint;
	import com.kavalok.location.modifiers.IClipModifier;
	
	import flash.debugger.enterDebugger;
	import flash.display.MovieClip;

	public class LocationEnterModifier implements IClipModifier
	{
		private var _location : LocationBase; 
		public function LocationEnterModifier(location : LocationBase)
		{
			_location = location;
		}

		public function accept(clip:MovieClip):Boolean
		{
			if(clip.parent == _location.content)
				return false;
				
			var result:Boolean = LocationEntryPoint.accept(clip);
			return result;
		}
		
		public function modify(clip:MovieClip):void
		{
			var point : LocationEntryPoint = new LocationEntryPoint(clip);
			_location.addPoint(point);	
		}
		
	}
}