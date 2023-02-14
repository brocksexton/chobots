package com.kavalok.gameWordTetris
{
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import com.kavalok.events.EventSender;
	
	public class WordBox extends Sprite
	{
		private var _startDragEvent:EventSender = new EventSender();
		private var _finishDragEvent:EventSender = new EventSender();
		
		private var _content:McWordBox = new McWordBox();
		private var _word:String;
		private var _chars:Sprite = new Sprite();
		private var _dragManager:DragManager;
		
		public function WordBox(word:String, bounds:Rectangle)
		{
			_word = word;
			
			addChild(_content);
			addChild(_chars);
			
			createChars();
			
			buttonMode = true;
			mouseChildren = false;
			
			_dragManager = new DragManager(this, null, bounds);
			_dragManager.startEvent.addListener(onStartDrag);
			_dragManager.finishEvent.addListener(onFinishDrag);
			
			cacheAsBitmap = true;
		}
		
		private function onFinishDrag(sender:DragManager):void
		{
			_finishDragEvent.sendEvent(this);
		}
		
		private function onStartDrag(sender:DragManager):void
		{
			_startDragEvent.sendEvent(this);
		}
		
		private function createChars():void
		{
			var totalWidth:int = 0;
			
			for (var i:int = 0; i < _word.length; i++)
			{
				var char:String = _word.charAt(i);
				
				var item:McCharBox = new McCharBox();
				item.charField.text = char;
				item.x = 0.5 * Config.CHAR_WIDTH + totalWidth;
				
				totalWidth += Config.CHAR_WIDTH;
				
				_chars.addChild(item);
			}
			
			_content.background.width = totalWidth + Config.CHAR_WIDTH;
		}
		
		public function destroy():void
		{
			_dragManager.enabled = false;
			
			var twean:Object =
			{
				x: x + 0.5 * width,
				y: y + 0.5 * height,
				alpha:0.5,
				scaleX:0,
				scaleY:0
			}
			
			new SpriteTweaner(this, twean, 5, null, onDestroyComplete);
		}
		
		private function onDestroyComplete(sender:Object):void
		{
			GraphUtils.detachFromDisplay(this);
		}
		
		public function get word():String { return _word; }
		
		public function get startDragEvent():EventSender { return _startDragEvent; }
		
		public function get finishDragEvent():EventSender { return _finishDragEvent; }
		
	}
	
}