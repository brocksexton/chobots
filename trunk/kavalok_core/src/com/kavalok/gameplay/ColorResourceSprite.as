package com.kavalok.gameplay
{
	import com.kavalok.utils.SpriteDecorator;
	
	import flash.display.Sprite;
	
	public class ColorResourceSprite extends ResourceSprite
	{
		private var _color : int;
		private var _colorSec : int;
		
		public function ColorResourceSprite(url:String, className:String, color : int = 0, autoLoad:Boolean=true, useView:Boolean=true, colorSec:int = 0)
		{
			super(url, className, autoLoad, useView);
			_color = color;
			_colorSec = colorSec;
			readyEvent.addListener(onReady);
		}
		
		private function onReady(sprite : ColorResourceSprite) : void
		{
			if (_color >= 0)
				SpriteDecorator.decorateColor(Sprite(sprite.content),_color,_colorSec);
		}
		
	}
}