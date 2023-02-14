package com.kavalok.gameChess
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChess.Chess;
	import com.kavalok.gameChess.data.ItemData;
	import com.kavalok.utils.GraphUtils;
	import flash.events.MouseEvent;
	import gameChess.McDefaultItem;
	import gameChess.McOverItem;
	import gameChess.McSelectedItem;
	import gameChess.McWarningItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Item extends Sprite
	{
		private var _clickEvent:EventSender = new EventSender(Item);
		
		private var _content:MovieClip;
		private var _data:ItemData;
		
		private var _selected:Boolean = false;
		private var _enabled:Boolean = false;
		private var _isMoved:Boolean = false;
		
		private var _defaultFilters:Array = getFilters(McDefaultItem);
		private var _selectedFilters:Array = getFilters(McSelectedItem);
		private var _warningFilters:Array = getFilters(McWarningItem);
		private var _overFilters:Array = getFilters(McOverItem);
		
		public function Item(data:ItemData)
		{
			this.data = data;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			selected = false;
			enabled = false;
			createContent();
		}
		
		public function set data(value:ItemData):void
		{
			if (_content && _data.type != value.type)
				GraphUtils.detachFromDisplay(_content);
				
			_data = value;
			
			if (_content)
				createContent();
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (_enabled)
				_clickEvent.sendEvent(this);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			if (_enabled && !_selected && isMy)
				this.filters = _overFilters;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			if (_enabled && !_selected && isMy)
				this.filters = _defaultFilters;
		}
		
		private function createContent():void
		{
			var spriteClass:Class = Chess.getClass(data.type);
			var frameNum:int = _data.playerNum + 1;
			
			_content = new spriteClass();
			_content.gotoAndStop(frameNum);
			_content.x = -0.5 * _content.width;
			_content.y = -_content.height;
			_content.cacheAsBitmap = true;
			_content.mouseEnabled = false;
			_content.mouseChildren = false;
			
			addChild(_content);
			refresh();
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			refresh();
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			this.buttonMode = value;
			
			if (!_enabled)
				this.filters = _defaultFilters;
		}
		
		public function set warning(value:Boolean):void
		{
			if (_selected && !value)
				return;
				
			this.filters = value
				? _warningFilters
				: _defaultFilters;
		}
		
		private function refresh():void
		{
			this.filters = _selected
				? _selectedFilters
				: _defaultFilters;
		}
		
		private function getFilters(classRef:Class):Array
		{
			return Sprite(Sprite(new classRef()).getChildAt(0)).filters;
		}
		
		public function get isMy():Boolean
		{
			return playerNum == GameChess.instance.playerNum;
		}
		
		public function get atBottom():Boolean
		{
			return _data.playerNum == 0;
		}
		
		public function get data():ItemData { return _data; }
		public function get id():int { return _data.id; }
		public function get type():String { return _data.type; }
		public function get row():int { return _data.row; }
		public function get col():int { return _data.col; }
		public function get playerNum():int { return _data.playerNum; }
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
		public function get isMoved():Boolean { return _isMoved; }
		
		public function set isMoved(value:Boolean):void
		{
			_isMoved = value;
		}
	}
	
}