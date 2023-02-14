
package com.kavalok.gameChoboard
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Background
	{
		private var _content:Sprite;
		private var _speed:int;
		private var _rect:Rectangle = new Rectangle();
		private var _right:int;
		
		public var y0:Number;
		
		public function Background(content:Sprite, speed:int, bounds:Rectangle)
		{
			_content = content;
			_speed = speed;
			
			_rect = bounds.clone();
			_right = content.getRect(content).right;
			_content.scrollRect = _rect;
			
			y0 = content.y;
		}
		
		public function move():void
		{
			_rect.x += speed;
			
			if (_rect.right >= _right)
				_rect.x = 0;
				
			_content.scrollRect = _rect;
		}
		
		public function get content():Sprite { return _content; }
		
		public function get speed():int { return _speed; }
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
		
	}
	
}
