package com.kavalok.gameMoney
{
	import com.kavalok.utils.EventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Stars extends Sprite
	{
		static private const CREATE_FREQ:Number = 0.05;
		
		public var events:EventManager;
		
		private var _items:Array = [];
		private var _content:Sprite;
		private var _bounds:Rectangle;
		private var _maxY:int;
		
		public function Stars(content:Sprite, bounds:Rectangle = null)
		{
			_content = content;
			_bounds = bounds;
			
			if (!_bounds)
				_bounds = _content.getBounds(_content);
			
			_maxY = _bounds.y + _bounds.height;
		}
		
		public function create():void
		{
			events.registerEvent(_content, Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function destroy():void
		{
			while (_items.length > 0)
			{
				removeItem(_items[0]);
			}
			events.removeEvent(_content, Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (Math.random() < CREATE_FREQ)
				createStar();
				
			for each (var item:Item in _items)
			{
				item.phase += 0.05;
				item.sprite.y += item.speed;
				item.sprite.x = item.xCoord + item.magnitude * Math.sin(item.phase)
				
				if (item.sprite.y > _maxY + item.sprite.height)
				{
					removeItem(item);
				}
			}
		}
		
		private function removeItem(item:Item):void
		{
			_content.removeChild(item.sprite);
			_items.splice(_items.indexOf(item), 1);
			
			if (_items.length == 0)
			{
				events.removeEvent(_content, Event.ENTER_FRAME, onEnterFrame);
			}
			
		}
		
		private function createStar():void
		{
			var  mc:McStar = new McStar();
			
			mc.x = Math.random() * _bounds.width;
			mc.y = _bounds.y - mc.height;
			//mc.cacheAsBitmap = true;
			mc.mouseEnabled = false;
			
			var item:Item = new Item();
			item.sprite = mc;
			item.xCoord = mc.x;
			item.speed = 1 + Math.random() * 3;
			item.magnitude = Math.random() * 100;
			
			_items.push(item);
			_content.addChild(mc);
		}
		
	}
}
import flash.display.Sprite;

internal class Item
{
	public var sprite:Sprite;
	public var speed:Number;
	public var xCoord:int;
	public var magnitude:int;
	public var phase:Number = 0;
}