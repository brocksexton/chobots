package com.kavalok.utils
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class KeyboardManager
	{
		private var _pressedKeys:Object = {};
		
		public function KeyboardManager(focus:DisplayObject)
		{
			focus.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			focus.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			focus.addEventListener(Event.DEACTIVATE, clearKeys);
		}
		
		private function clearKeys(e:Event):void
		{
			_pressedKeys = {};
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			_pressedKeys[e.keyCode] = true;
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			delete _pressedKeys[e.keyCode];
		}
		
		public function isKeyPressed(keyCode:int):Boolean
		{
			return (keyCode in _pressedKeys);
		}
	}
}