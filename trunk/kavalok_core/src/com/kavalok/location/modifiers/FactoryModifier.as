package com.kavalok.location.modifiers
{
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;

	public class FactoryModifier implements IClipModifier
	{
		private var _factoryClass : Class;
		private var _prefix : String;
		private var _location:LocationBase;
		
		public function FactoryModifier(prefix : String, factoryClass : Class, location:LocationBase = null)
		{
			_factoryClass = factoryClass;
			_prefix = prefix;
			_location = location;
		}

		public function accept(clip:MovieClip):Boolean
		{
			return Strings.startsWidth(clip.name, _prefix);
		}
		
		public function modify(clip:MovieClip):void
		{
			if (_location)
				new _factoryClass(clip, _location);
			else
				new _factoryClass(clip);
		}
		
	}
}