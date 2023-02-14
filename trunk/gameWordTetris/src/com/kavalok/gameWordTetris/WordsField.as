package com.kavalok.gameWordTetris
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class WordsField
	{
		private var _content:McWordsField;
		private var _items:Sprite = new Sprite();
		private var _events:EventManager = GameWordTetris.instance.eventManager;
		
		public function WordsField(content:McWordsField)
		{
			_content = content;
			GraphUtils.attachBefore(_items, _content.border);
			_items.mask = _content.maskClip;
			
			_events.registerEvent(_content, Event.ENTER_FRAME, processItems);
		}
		
		private function processItems(e:Event):void
		{
			for (var i:int = 0; i < _items.numChildren; i++)
			{
				var item:Sprite = _items.getChildAt(i) as Sprite;
				item.y += Config.ITEM_SPEED;
				
				if (item.y > _content.background.y + content.background.height)
					resetItem(item);
			}
		}
		
		private function resetItem(item:Sprite):void
		{
			GraphUtils.changeParent(item, _content);
			item.x = int(Math.random() * (_content.background.width - item.width));
			item.y = -item.height;
			
			while (item.hitTestObject(_items))
				item.y -= item.height;
			
			GraphUtils.roundCoords(item);
			GraphUtils.changeParent(item, _items);
		}
		
		public function addItem(item:WordBox):void
		{
			_items.addChild(item);
			resetItem(item);
		}
		
		public function get content():McWordsField { return _content; }
	}
	
}