package com.kavalok.gameMoney
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Cell
	{
		static private const START_VY:Number = -25;
		static private const VX_KOEF:Number = 0.1;
		static private const ALPHA_KOEF:Number = 1;
		static private const GRAVITY:Number = 2;
		static private const MOVE_DOWN_SPEED:Number = 0;
		
		public var type:int;
		
		public var content:Sprite;
		public var col:int;
		public var row:int;
		
		public var overHandler:Function;
		public var outHandler:Function;
		public var pressHandler:Function;
		public var moveCompleteHandler:Function;
		public var destroyHandler:Function;
		public var events:EventManager;
		
		public var selectionFilters:Array;
		public var maxY:Number;
		public var endY:Number;
		
		private var _selected:Boolean;
		private var _vy:Number;
		private var _vx:Number;
		private var _model:MovieClip;
		private var _models:Array = [McCoin1, McCoin2, McCoin3, McCoin5, McCoin10, McCoin25];
		
		public function Cell(type:int, events:EventManager)
		{
			this.type = type;
			this.events = events;
			
			_model = new _models[type];
			_model.stop();
			
			content = new Sprite();
			content.addChild(_model);
			
			content.scaleX = Config.CELL_SCALE
			content.scaleY = Config.CELL_SCALE;
			
			content.buttonMode = true;
			content.cacheAsBitmap = true;
			
			content.graphics.beginFill(0x000000, 0);
			content.graphics.drawRect( -0.5 * _model.width, -0.5 * _model.height, _model.width, _model.height);
			content.graphics.endFill();
			
			var bounds:Rectangle = _model.getBounds(content);
			_model.x -= 0.5 * (bounds.left + bounds.right);
			_model.y -= 0.5 * (bounds.top + bounds.bottom);
			
			events.registerEvent(content, MouseEvent.MOUSE_OVER, onMouseOver);
			events.registerEvent(content, MouseEvent.MOUSE_DOWN, onMouseDown);
			events.registerEvent(content, MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function doDestroyAction():void
		{
			GraphUtils.bringToFront(content);
			GraphUtils.disableMouse(content);
			
			//selected = false;
			
			_vy = Math.random() * START_VY;
			_vx = -VX_KOEF * content.mouseX
			
			events.removeEvents(content);
			events.registerEvent(content, Event.ENTER_FRAME, onDestroyFrame);
		}
		
		private function onDestroyFrame(e:Event):void
		{
			/*if (_model.currentFrame < _model.totalFrames)
			{
				_model.nextFrame();
			}
			else
			{
				content.alpha *= ALPHA_KOEF;
			}*/
			
			content.y += _vy;
			content.x += _vx;
			
			_vy += GRAVITY;
			
			if (content.y > maxY)
			{
				events.removeEvents(content);
				destroyHandler(this);
			}
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			overHandler(this);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			outHandler(this);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			pressHandler(this);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			if (_selected)
				content.filters = selectionFilters;
			else
				content.filters = [];
		}
		
		public function moveDown():void
		{
			_vy = MOVE_DOWN_SPEED;
			events.registerEvent(content, Event.ENTER_FRAME, onMoveDown);
		}
		
		private function onMoveDown(e:Event):void
		{
			content.y += _vy;
			_vy += GRAVITY;
			
			if (content.y >= endY)
			{
				content.y = endY;
				events.removeEvent(content, Event.ENTER_FRAME, onMoveDown);
				moveCompleteHandler(this);
			}
		}
		
	}
	
}