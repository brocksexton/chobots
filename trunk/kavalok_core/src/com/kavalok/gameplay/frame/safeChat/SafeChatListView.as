package com.kavalok.gameplay.frame.safeChat
{
	import com.kavalok.layout.TileLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	
	public class SafeChatListView
	{
		private var _content : Sprite;

		private var _layout : TileLayout;
		private var _itemClick : EventSender = new EventSender(String);
		
		private var _items : Array;
		private var _views : Array = [];

		public function SafeChatListView(content : Sprite = null, items : Array = null, maxItems : uint = 0, scroll : Boolean = false)
		{
			_content = content || new Sprite();
			if(scroll)
			{
				_content.scrollRect = new Rectangle(0, 0, _content.width, _content.height);
			}
			_layout = new TileLayout(_content);
			_layout.offset = new Point(4, 0);
			_layout.maxItems = maxItems;
			_items = items || [];
			
			
			for each(var id : String in _items)
			{
				doAdditem(id);
			}
			_layout.apply();
		}

		public function get itemClick() : EventSender
		{
			return _itemClick;
		}
		
		public function get content() : Sprite
		{
			return _content;
		}
		
		public function get items() : Array
		{
			return _items;
		}
		
		public function removeLast() : void
		{
			var item : SafeChatItemView = _views.pop();
			_items.pop();
			item.content.removeEventListener(MouseEvent.CLICK, onItemClick);
			_content.removeChild(item.content);
			
			scroll();
		}
		
		public function addItem(id : String) : void
		{
			doAdditem(id);
			_items.push(id);
			_layout.apply();
			scroll();
		}
		
		public function clear() : void
		{
			_items = [];
			_views = [];
			GraphUtils.removeChildren(_content);
		}
		
		private function scroll() : void
		{
			var rect : Rectangle = _content.scrollRect;
			var width : Number = 0;
			for each(var view : SafeChatItemView in _views)
				width += view.content.width;
				
			rect.x = (rect.width < width) ? width - rect.width : 0;
			_content.scrollRect = rect;
		}
		private function doAdditem(id : String) : void
		{
			var item : SafeChatItemView = new SafeChatItemView(id);
			_content.addChild(item.content);
			_views.push(item);
			item.content.addEventListener(MouseEvent.CLICK, onItemClick, false, 0, true);
		}
		private function onItemClick(event : MouseEvent) : void
		{
			itemClick.sendEvent(event.currentTarget.id);
		}
	}
}