package com.kavalok.gameChopaj
{
	import com.kavalok.events.EventSender;
	import com.kavalok.flash.geom.Point;
	import com.kavalok.gameChopaj.data.FireData;
	import com.kavalok.gameChopaj.data.ItemData;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import gameChopaj.McItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Item extends Sprite
	{
		public var v:Vector2D = new Vector2D();
		public var radius:Number = 14;
		public var weight:Number = 1;
		
		private var _pressEvent:EventSender = new EventSender(Item);
		private var _fireEvent:EventSender = new EventSender(Item);
		
		private var _content:McItem = new McItem();
		private var _arrow:MovieClip;
		private var _data:ItemData;
		private var _fireData:FireData = new FireData();
		
		public function Item(data:ItemData)
		{
			_data = data;
			
			_fireData.itemIndex = _data.index;
			
			_content.cacheAsBitmap = false;
			_content.mouseChildren = false;
			_content.buttonMode = isMy;
			_content.gotoAndStop(_data.playerNum + 1);
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_content.hitAreaClip.visible = false;
			_arrow = _content.arrow;
			
			this.x = _data.x;
			this.y = _data.y;
			
			selected = false;
			enabled = false;
			
			addChild(_content);
		}
		
		public function get hit():Sprite
		{
			return _content.hitAreaClip;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (!_content.contains(_arrow))
				_pressEvent.sendEvent(this);
			else
				_fireEvent.sendEvent(this);
		}
		
		private function onMouseMove(e:MouseEvent = null):void
		{
			var angle:Number = Math.atan2(_content.mouseX, -_content.mouseY);
			var distance:Number = GraphUtils.distance(
				new Point(_content.mouseX, _content.mouseY),
				new Point());
			
			_fireData.power = GraphUtils.claimRange(distance / 30.0, 0, 1);
			_fireData.direction = angle + Math.PI / 2;
			
			_arrow.content.scaleX = GraphUtils.claimRange(_fireData.power, 0.5, 1);
			_arrow.rotation =  _fireData.direction / Math.PI * 180;
			
			if (e) e.updateAfterEvent();
		}
		
		public function set selected(value:Boolean):void
		{
			_content.selection.visible = value && !isMy;
			var arrowVisible:Boolean = value && isMy;
			
			if (arrowVisible && !_content.contains(_arrow))
				_content.addChild(_arrow);
			
			if (!arrowVisible && _content.contains(_arrow))
				_content.removeChild(_arrow);
			
			if (arrowVisible)
				showSight();
		}
		
		private function showSight():void
		{
			_content.arrow.visible = true;
			_content.arrow.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_content.arrow.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			GraphUtils.bringToFront(this);
			onMouseMove();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			selected = false;
		}
		
		public function set enabled(value:Boolean):void
		{
			_content.mouseEnabled = value;
			_content.mouseChildren = value;
		}
		
		public function get atBottom():Boolean
		{
			return _data.playerNum == 0;
		}
		
		public function get isMy():Boolean
		{
			return data.playerNum == Game.instance.playerNum;
		}
		
		public function updateData():void
		{
			_data.x = this.x;
			_data.y = this.y;
		}
		
		public function get data():ItemData
		{
			return _data;
		}
		
		public function get playerNum():int
		{
			return _data.playerNum;
		}
		
		public function get fireData():FireData { return _fireData; }
		
		public function get pressEvent():EventSender { return _pressEvent; }
		public function get fireEvent():EventSender { return _fireEvent; }
		
	}
	
}