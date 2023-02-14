package com.kavalok.utils
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.commands.MoveCharCommand;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	public class MoveDemChars
	{
		static private var _instance:MoveDemChars;
		
		static public function get instance():MoveDemChars
		{
			if (!_instance)
				_instance = new MoveDemChars();
			
			return _instance;	
		}
		
		private var _started:Boolean = false;
		public function get started():Boolean { return _started; }
		public function set started(value:Boolean):void
		{
			if (value != _started)
			{
			 	_started = value;
			 	if (_started)
			 		start();
			 	else
			 		stop();
			}
		}
		
		private var _dragManager:DragManager;
		private var _item:Sprite;
		
		public function MoveDemChars()
		{
			super();
		}
		
		private function start():void
		{
			Global.locationContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			Global.locationContainer.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		private function stop():void
		{
			Global.locationContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == 27){
					Global.locationManager.location.sendResetObjectPositions();
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{

			if (e.ctrlKey)
			{
				if (location)
				{
					if (e.altKey)
						_item = location.charContainer;
					else if (e.shiftKey)
						_item = location.background;
					else if (e.shiftKey && e.altKey)
					    _item = location.ground;
					else 
					    _item = resolveItem(new Point(e.stageX, e.stageY));
						
					if (_item)
					{
						startDrag();
					}
				}
				e.stopPropagation();
			}
		}
		
		private function startDrag():void
		{
			_dragManager = new DragManager(_item);
			_dragManager.startDrag();
			_dragManager.finishEvent.addListener(onDragComplete);
			Global.locationContainer.addEventListener(MouseEvent.CLICK, onClick, true);
		}
		
		private function onClick(e:MouseEvent):void
		{
			Global.locationContainer.removeEventListener(MouseEvent.CLICK, onClick, true);
			e.stopPropagation();
		}
		
		private function onDragComplete(sender:DragManager):void
		{
			if (location)
				sendAction();
			_dragManager.enabled = false;
		}
		
		private function sendAction():void
		{
			var char:LocationChar = getChar();
			if (char)
			{
				var command:MoveCharCommand = new MoveCharCommand(char.id, char.position);
				location.sendCommand(command);
			}
			else
			{
				location.sendObjectPosition(_item, GraphUtils.objToPoint(_item));
			}
		}
		
		private function getChar():LocationChar
		{
			for each (var char:LocationChar in location.chars)
			{
				if (char.content == _item)
					return char;	
			}
			return null;
		}
		
		private function resolveItem(position:Point):Sprite
		{
			var items:Array = Global.locationContainer.getObjectsUnderPoint(position);
			var topItem:DisplayObject = items.pop();
			
			while (topItem && topItem.parent)
			{
				if ((topItem.parent==location.content
						|| topItem.parent==location.charContainer
						|| topItem.parent==location.background)
					&& topItem != location.background
					&& topItem != location.ground)
				{
					break;
				}
				topItem = topItem.parent
			}
			return topItem as Sprite;
		}
		
		public function get location():LocationBase
		{
			 return Global.locationManager.location;
		}
	}
}