package com.kavalok.gameplay.controls
{
	import com.kavalok.events.EventSender;
	
	import flash.display.Sprite;
	
	public class ListBox
	{
		private var _content:Sprite;
		private var _items:Array = [];
		private var _refreshEvent:EventSender = new EventSender();
		
		public function ListBox(content:Sprite = null)
		{
			_content = (content) ? content : new Sprite();
		}
		
		public function clear():void
		{
			while (_items.length > 0)
			{
				removeItem(_items[0]);
			}
		}
		
		public function addItem(item:IListItem):void
		{
			_items.push(item);
			_content.addChild(item.content);
		}
		
		public function removeItem(item:IListItem):void
		{
			_items.splice(_items.indexOf(item), 1);
			_content.removeChild(item.content);
		}
		
		public function refresh():void
		{
			rebuildContent();
			_refreshEvent.sendEvent(this);
		}
		
		private function rebuildContent():void
		{
			var y:int = 0;
			
			for each (var item:IListItem in _items)
			{
				item.content.y = y;
				y += item.content.height;
			}
		}
		
		public function get refreshEvent():EventSender
		{
			 return _refreshEvent;
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		public function get items():Array
		{
			 return _items;
		}

	}
}