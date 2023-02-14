package com.kavalok.location
{
	import com.kavalok.char.Directions;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class MoveByPathAction
	{
		public var onDirectionChange:Function;
		public var onComplete:Function;
		
		private var _counter:int;
		private var _dx:Number;
		private var _dy:Number;
		
		private var _content:DisplayObject;
		private var _executed:Boolean = false;
		
		public function get content():DisplayObject
		{
			 return _content;
		}
		
		private var _path:Array;
		private var _speed:Number;
		
		
		public function MoveByPathAction(content:DisplayObject, path:Array = null, speed:Number = 1)
		{
			_content = content;
			
			initilize(path, speed);
		}
		
		public function initilize(path:Array, speed:Number):void
		{
			if (path)
			{
				_path = path.slice();
				_path.splice(0, 1);
			}
			
			_speed = speed;
		}
		
		public function execute():void
		{
			if (_executed)
				stopMoving();
				
			_executed = true;				
			
			_content.addEventListener(Event.REMOVED_FROM_STAGE, stopMoving);
			_content.addEventListener(Event.ENTER_FRAME, processMoving);
			
			moveToPath();
		}
		
		private function moveToPath():void
		{
			if (_path.length == 0)
			{
				stopMoving();
				handle(onComplete);
				return;
			}
			
			var dx:Number = _path[0].x - _content.x;
			var dy:Number = _path[0].y - _content.y;
			var distance:Number = Math.sqrt(dx*dx + dy*dy);
			
			if (onDirectionChange != null)
				onDirectionChange(Directions.getDirection(dx, dy));
			
			_counter = Math.ceil(distance/_speed);
			
			_dx = dx/_counter;
			_dy = dy/_counter;
			
			_path.splice(0, 1);
		}
		
		private function processMoving(e:Event):void
		{
			_content.x += _dx;
			_content.y += _dy;
			
			if (--_counter == 0)
			{
				moveToPath();
			}
		}
		
		public function stopMoving(e:Event = null):void
		{
			if (_executed)
			{
				_executed = false;
				_content.removeEventListener(Event.REMOVED_FROM_STAGE, stopMoving);
				_content.removeEventListener(Event.ENTER_FRAME, processMoving);
			}
		}
		
		private function handle(func:Function):void
		{
			if (func != null)
				func(this);
		}
		
		public function get executed():Boolean { return _executed; }
	}
}

