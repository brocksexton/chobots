package com.kavalok.utils
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class DragManager
	{
		public var enabled:Boolean = true;
		public var tag:*;
		
		public var dragAlpha : Number = 1;
		
		private var _startEvent:EventSender = new EventSender(DragManager);
		private var _finishEvent:EventSender = new EventSender(DragManager);
		private var _dragEvent:EventSender = new EventSender(DragManager);
		
		private var _content:Sprite;
		private var _hitArea:InteractiveObject;
		private var _bounds:Rectangle;
		
		private var _xDiff:Number;
		private var _yDiff:Number;
		
		private var _x0:Number;
		private var _y0:Number;
		private var _finished:Boolean;

		private var _previousAlpha:Number;
		
		public function DragManager(content:Sprite, hitArea:InteractiveObject = null, bounds:Rectangle = null)
		{
			if (content == null)
			{
				throw new Error('Value cannot be null');
				return;
			}
			
			_content = content;
			_hitArea = (hitArea) ? hitArea : content;
			_bounds = bounds;
			
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_x0 = content.x;
			_y0 = content.y;
		}
		
		public function get finished() : Boolean
		{
			return _finished;
		}
			
		private function onMouseDown(e:MouseEvent):void
		{
			startDrag();
		}
		
		public function startDrag():void
		{
			if (!enabled) 
				return;
			
			_previousAlpha = _content.alpha;
			_content.alpha = dragAlpha;
			_content.cacheAsBitmap = true;
			_startEvent.sendEvent(this);
			
			_x0 = _content.x;
			_y0 = _content.y;
			
			_xDiff = _content.parent.mouseX - _content.x;
			_yDiff = _content.parent.mouseY - _content.y;
			
			Global.root.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Global.root.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function stop():void
		{
			Global.root.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Global.root.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_content.alpha = _previousAlpha;
			_content.cacheAsBitmap = false;
			_finished = true;
		}
		public function undoDrag():void
		{
			_content.x = _x0;
			_content.y = _y0;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var bounds:Rectangle = _content.getBounds(_content.parent);
			
			var dx:Number = _content.parent.mouseX - _xDiff - _content.x;
			var dy:Number = _content.parent.mouseY - _yDiff - _content.y;
			
			
			if (dx != 0 || dy != 0)
			{
				_content.x += dx;
				_content.y += dy;
				
				if (_bounds)
					GraphUtils.claimBounds(_content, _bounds);
				
				_content.x = int(_content.x);
				_content.y = int(_content.y);
				
				e.updateAfterEvent();
				_dragEvent.sendEvent(this);
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			stop();
			_finishEvent.sendEvent(this);
		}
		
		public function get startEvent():EventSender { return _startEvent; }
		
		public function get finishEvent():EventSender { return _finishEvent; }
		
		public function get dragEvent():EventSender { return _dragEvent; }
		
		public function get bounds():Rectangle { return _bounds; }
		
		public function set bounds(value:Rectangle):void 
		{
			_bounds = value;
		}
		
		public function get content():Sprite { return _content; }
		
	}
}