package com.kavalok.location.modifiers
{
	import com.kavalok.struct.ColorInfo;
	
	import flash.display.Sprite;

	public class CharContainerColorModifier extends LocationColorModifier
	{
		private static var _prevColorInfo:ColorInfo = new ColorInfo();
		
		public function CharContainerColorModifier()
		{
			super();
		}
		
		override protected function get target():Sprite
		{
			return location.charContainer;
		}
		
		override protected function get prevColorInfo():ColorInfo
		{
			return _prevColorInfo;
		}
		
		override protected function set prevColorInfo(value:ColorInfo):void
		{
			_prevColorInfo = value;
		}
		
	}
}