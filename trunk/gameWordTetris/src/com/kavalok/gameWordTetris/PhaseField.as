package com.kavalok.gameWordTetris
{
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.TaskCounter;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.kavalok.events.EventSender;
	
	public class PhaseField
	{
		private var _phraseEvent:EventSender = new EventSender();
		
		private var _content:McPhraseClip;
		private var _items:Sprite = new Sprite();
		private var _maxChars:int = 0;
		
		public function PhaseField(content:McPhraseClip)
		{
			_content = content;
			_content.addChild(_items);
			
			initField();
		}
		
		private function initField():void
		{
			_items.x = 0.5 * Config.CHAR_WIDTH;
			_items.y = 0.5 * content.height - 0.5 * Config.CHAR_HEIGH;
			
			var totalWidth:int = 0;
			
			while (totalWidth < _content.background.width - 2 * Config.CHAR_WIDTH)
			{
				var item:McCharDecorator = new McCharDecorator();
				item.x = 0.5 * Config.CHAR_WIDTH + totalWidth;
				item.y = 0.5 * content.height - 0.5 * Config.CHAR_HEIGH;
				
				totalWidth += Config.CHAR_WIDTH;
				
				_content.background.addChild(item);
				
				_maxChars++;
			}
		}
		
		public function addItem(item:WordBox):void
		{
			GraphUtils.changeParent(item, _items);
			applyPlacement();
			_items.mouseChildren = false;
		}
		
		public function applyPlacement():void
		{
			var items:Array = getSortedItems();
			var totalWidth:int = 0;
			var task:TaskCounter = new TaskCounter();
			
			for each (var item:WordBox in items)
			{
				var twean:Object =
				{
					x: totalWidth,
					y: 0
				}
				
				task.addCount();
				task.completeEvent.addListener(onPlacementComplete);
				new SpriteTweaner(item, twean, 5, null, task.completeTask);
				
				totalWidth += item.width;
			}
		}
		
		public function accept(word:String):Boolean
		{
			return getPhrase().length + word.length + 1 < _maxChars;
		}
		
		public function clear():void
		{
			while (_items.numChildren > 0)
			{
				var item:WordBox = _items.getChildAt(0) as WordBox;
				GraphUtils.changeParent(item, _content);
				item.destroy();
			}
		}
		
		private function onPlacementComplete():void
		{
			_items.mouseChildren = true;
			phraseEvent.sendEvent();
		}
		
		public function getPhrase():String
		{
			var items:Array = getSortedItems();
			var phrase:String = '';
			
			for (var i:int = 0; i < items.length; i++)
			{
				phrase += WordBox(items[i]).word;
				
				if (i < items.length - 1)
					phrase += ' ';
			}
			
			return phrase;
		}
		
		private function getSortedItems():Array
		{
			var result:Array = [];
			
			for (var i:int = 0; i < _items.numChildren; i++)
			{
				result.push(_items.getChildAt(i));
			}
			
			return result.sortOn('x', Array.NUMERIC);
		}
		
		public function get content():Sprite { return _content; }
		
		public function get phraseEvent():EventSender { return _phraseEvent; }
		
	}
	
}