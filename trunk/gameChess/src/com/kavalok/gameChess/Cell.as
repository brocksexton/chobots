package com.kavalok.gameChess
{
	import com.kavalok.events.EventSender;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gameChess.McFieldDark;
	import gameChess.McFieldLight;
	
	public class Cell extends Sprite
	{
		private var _pressEvent:EventSender = new EventSender(Cell);
		
		private var _content:MovieClip;
		private var _item:Item;
		private var _row:int;
		private var _col:int;
		
		public function Cell(row:int, col:int)
		{
			_row = row;
			_col = col;
			
			_content = ((row + col) % 2 == 0)
				? new McFieldLight()
				: new McFieldDark();
			
			_content.addEventListener(MouseEvent.CLICK, onMouseClick);
			enabled = false;
			addChild(_content);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_pressEvent.sendEvent(this);
		}
		
		public function set enabled(value:Boolean):void
		{
			_content.buttonMode = value;
			_content.mouseEnabled = value;
			
			var frameNum:int = (value) ? 2 : 1;
			_content.gotoAndStop(frameNum);
		}
		
		public function get enabled():Boolean
		{
			return (_content.currentFrame == 2);
		}
		
		public function get isEmpty():Boolean
		{
			return _item == null;
		}
		
		public function get isMy():Boolean
		{
			return _item && _item.isMy;
		}
		
		public function get isHis():Boolean
		{
			return _item && !_item.isMy;
		}
		
		public function get item():Item { return _item; }
		
		public function set item(value:Item):void
		{
			_item = value;
		}
		
		public function get pressEvent():EventSender { return _pressEvent; }
		
		public function get row():int { return _row; }
		public function get col():int { return _col; }
	}
	
}