package com.kavalok.gameplay.controls
{
	import flash.display.Sprite;

	public class FlashViewBase implements IFlashView
	{
		private var _content : Sprite;
		
		public function FlashViewBase(content : Sprite)
		{
			_content = content; 
		}

		public function get content():Sprite
		{
			return _content;
		}
		
	}
}