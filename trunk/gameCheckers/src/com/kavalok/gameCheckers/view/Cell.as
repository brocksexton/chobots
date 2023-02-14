package com.kavalok.gameCheckers.view
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameCheckers.CellStates;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Cell extends Sprite
	{
		private var _pressEvent:EventSender = new EventSender(Cell);
		
		private var _item:Item;
		private var _content:MovieClip;
		private var _row:int;
		private var _col:int;
		
		public function Cell(contentClass:Class, row:int, col:int)
		{
			_row = row;
			_col = col;
			
			_content = new contentClass();
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
			
			if (value)
				_content.gotoAndStop(2);
			else
				_content.gotoAndStop(1);
		}
		
		public function get state():String
		{
			if (_item == null)
				return CellStates.EMPTY;
			else if (_item.isMy)
				return CellStates.MY;
			else
				return CellStates.HIS;
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