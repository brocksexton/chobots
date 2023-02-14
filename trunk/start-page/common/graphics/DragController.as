package common.graphics
{
	import common.events.EventSender;
	import common.utils.GraphUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Canab
	*/
	public class DragController
	{
		public var enabled:Boolean = true;
		public var lockHorizontal:Boolean = false;
		public var lockVertical:Boolean = false;
		
		private var _startEvent:EventSender = new EventSender(this);
		private var _finishEvent:EventSender = new EventSender(this);
		private var _dragEvent:EventSender = new EventSender(this);
		
		private var _content:Sprite;
		private var _hitArea:Sprite;
		private var _bounds:Rectangle;
		
		private var _xDiff:Number;
		private var _yDiff:Number;
		
		private var _x0:Number;
		private var _y0:Number;
		
		private var _positionChanged:Boolean = false;
		
		public function DragController(content:Sprite, hitArea:Sprite = null)
		{
			_content = content;
			_hitArea = (hitArea) ? hitArea : content;
			
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_x0 = content.x;
			_y0 = content.y;
		}
			
		private function onMouseDown(e:MouseEvent):void
		{
			if (enabled)
				startDrag();
		}
		
		private function startDrag():void
		{
			_x0 = _content.x;
			_y0 = _content.y;
			
			_xDiff = _content.parent.mouseX - _content.x;
			_yDiff = _content.parent.mouseY - _content.y;
			
			_hitArea.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_hitArea.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_hitArea.stage.addEventListener(Event.ENTER_FRAME, onFrame);
			
			_startEvent.sendEvent();
		}
		
		public function undo():void
		{
			_content.x = _x0;
			_content.y = _y0;
		}
		
		private function onFrame(e:Event):void
		{
			if (_positionChanged)
			{
				_positionChanged = false;
				_dragEvent.sendEvent();
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var oldX:Number = _content.x;
			var oldY:Number = _content.y;
			
			if (!lockHorizontal)
				_content.x += _content.parent.mouseX - _xDiff - _content.x;
				
			if (!lockVertical)
				_content.y += _content.parent.mouseY - _yDiff - _content.y;
			
			if (_bounds)
			{
				var rect:Rectangle = _content.getBounds(_content.parent);
				
				if (!lockHorizontal)
				{
					if (rect.left < _bounds.left)
						_content.x += _bounds.left - rect.left;
					else if (rect.right > _bounds.right)
						_content.x += _bounds.right - rect.right;
				}
				
				if (!lockVertical)
				{
					if (rect.top < _bounds.top)
						_content.y += _bounds.top - rect.top;
					else if (rect.bottom > _bounds.bottom)
						_content.y += _bounds.bottom - rect.bottom;
				}
			}
				
			if (_content.x != oldX || _content.y != oldY)
			{
				_positionChanged = true;
				e.updateAfterEvent();
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_hitArea.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_hitArea.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_hitArea.stage.removeEventListener(Event.ENTER_FRAME, onFrame);
			
			_finishEvent.sendEvent();
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