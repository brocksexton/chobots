package com.kavalok.gameCheckers.view
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameCheckers.data.ItemData;
	import gameCheckers.McItemDark;
	import gameCheckers.McItemLight;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Item extends Sprite
	{
		private var _pressEvent:EventSender = new EventSender(Item);
		
		private var _content:MovieClip;
		private var _data:ItemData;
		
		public function Item(data:ItemData)
		{
			_data = data;
			
			_content = (_data.playerNum == 0)
				? new McItemLight()
				: new McItemDark();
				
			
			_content.cacheAsBitmap = true;
			_content.mouseChildren = false;
			_content.buttonMode = isMy;
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			selected = false;
			enemySign = false;
			enabled = false;
			
			refresh();
			
			addChild(_content);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_pressEvent.sendEvent(this);
		}
		
		public function setCoords(row:int, col:int):void
		{
			_data.row = row;
			_data.col = col;
		}
		
		public function set selected(value:Boolean):void
		{
			_content.selection.visible = value;
		}
		
		public function set enemySign(value:Boolean):void
		{
			_content.enemySign.visible = value;
		}
		
		public function set enabled(value:Boolean):void
		{
			_content.mouseEnabled = value;
			_content.mouseChildren = value;
			//_content.alpha = value ? 1 : 0.5;
		}
		
		public function get row():int
		{
			return _data.row;
		}
		
		public function get col():int
		{
			return _data.col;
		}
		
		public function get isKing():Boolean
		{
			return _data.isKing;
		}
		
		public function set isKing(value:Boolean):void
		{
			_data.isKing = value;
			
			refresh();
		}
		
		private function refresh():void
		{
			if (_data.isKing)
				_content.gotoAndStop(2);
			else
				_content.gotoAndStop(1);
		}
		
		public function get atBottom():Boolean
		{
			return _data.playerNum == 0;
		}
		
		public function get isMy():Boolean
		{
			return data.playerNum == GameCheckers.instance.playerNum;
		}
		
		public function get data():ItemData { return _data; }
		
		public function get pressEvent():EventSender { return _pressEvent; }
	}
	
}