package com.kavalok.gameplay
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class StarField
	{
		private var _content:Sprite;
		private var _head:Star;
		private var _bounds:Rectangle;
		
		public function StarField(bounds:Rectangle, content:Sprite = null)
		{
			_bounds = bounds;
			_content = (content)
				? content
				: new Sprite();
		}
		
		public function createStars(starClass:Class, numStars:int):void
		{
			for (var i:int = 0; i < numStars; i++)
			{
				var mc:Sprite = new starClass();
				var star:Star = new Star(mc);
				
				star.content.x = _bounds.left + Math.random() * _bounds.width;
				star.content.y = _bounds.top + Math.random() * _bounds.height;
				
				star.next = _head;
				_head = star;
				
				_content.addChild(star.content);
			}
		}
		
		public function move(distX:int, distY:int):void
		{
			var star:Star = _head;
			
			while (star)
			{
				var mc:Sprite = star.content;
				
				mc.x += distX * star.moveMultiplier;
				mc.y += distY * star.moveMultiplier;
				
				var rect:Rectangle = mc.getBounds(_content);
				
				if (rect.right < _bounds.left)
					mc.x += _bounds.right - rect.left;
				else if (rect.left > _bounds.right)
					mc.x -= rect.right  - _bounds.left;
				
				if (rect.bottom < _bounds.top)
					mc.y += _bounds.bottom - rect.top;
				else if (rect.top > _bounds.bottom)
					mc.y -= rect.bottom  - _bounds.top;
				
				star = star.next;
			}
		}
		
		public function get content():Sprite { return _content; }
		
	}
}

import flash.display.Sprite;
import flash.geom.ColorTransform;

internal class Star
{
	public var content:Sprite;
	public var next:Star;
	public var moveMultiplier:Number;
	
	public function Star(content:Sprite)
	{
		this.content = content;
		
		content.cacheAsBitmap = true;
		content.scaleX = content.scaleY = Math.random();
		content.alpha = 0.5;
		
		moveMultiplier = Math.random();
	}
}
