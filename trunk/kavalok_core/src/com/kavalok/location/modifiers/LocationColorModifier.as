package com.kavalok.location.modifiers
{
	import com.gskinner.geom.ColorMatrix;
	import com.kavalok.struct.ColorInfo;
	import com.kavalok.utils.ReflectUtil;
	
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	import gs.TweenLite;

	public class LocationColorModifier extends LocationModifierBase
	{
		private static var _prevColorInfo:ColorInfo = new ColorInfo();
		
		private var _colorInfo:ColorInfo;
		private var _nextColorInfo:ColorInfo;
		
		public function LocationColorModifier()
		{
			super();
		}
		
		override public function apply():void
		{
			var newInfo:ColorInfo = new ColorInfo();
			ReflectUtil.copyFieldsAndProperties(parameters, newInfo);
			setColor(newInfo);
		}
		
		override public function restore():void
		{
			setColor(new ColorInfo());
		}
		
		private function setColor(info:ColorInfo):void
		{
			_colorInfo = new ColorInfo();
			ReflectUtil.copyFieldsAndProperties(prevColorInfo, _colorInfo);
			prevColorInfo = _colorInfo;
			
			var tween:Object = 
			{
				red:	info.red,
				green:	info.green,
				blue:	info.blue,
				hue:	info.hue,
				saturation:	info.saturation,
				brightness:	info.brightness,
				contrast: info.contrast,
				onUpdate: updateColor
			}
				
			TweenLite.to(_colorInfo, 1, tween);
		}
		
		private function updateColor():void
		{
			target.transform.colorTransform = new ColorTransform(
				_colorInfo.red,
				_colorInfo.green,
				_colorInfo.blue);
				
			var matrix:ColorMatrix= new ColorMatrix();
			matrix.adjustColor(
				_colorInfo.brightness,
				_colorInfo.contrast,
				_colorInfo.saturation,
				_colorInfo.hue);
				
			if (_colorInfo.brightness == 0
				&& _colorInfo.contrast == 0
				&& _colorInfo.saturation == 0
				&& _colorInfo.hue == 0)
			{
				target.filters = []
			}
			else
			{
				target.filters = [new ColorMatrixFilter(matrix)];
			}
		}
		
		protected function get target():Sprite
		{
			return location.content;
		}
		
		protected function get prevColorInfo():ColorInfo
		{
			return _prevColorInfo;
		}
		
		protected function set prevColorInfo(value:ColorInfo):void
		{
			_prevColorInfo = value;
		}
		
	}
}