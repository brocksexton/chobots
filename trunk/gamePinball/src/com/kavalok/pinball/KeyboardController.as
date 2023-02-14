package com.kavalok.pinball
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class KeyboardController extends PinballControllerBase
	{
		private static const PUSH_RIGHT : uint = 190;
		private static const PUSH_LEFT : uint = 88;
		private static const LEFT : uint = 90;
		private static const RIGHT : uint = 191;
		
		
		public function KeyboardController(pinball:GamePinball)
		{
			super(pinball);
			pinball.eventManager.registerEvent(pinball.stage, KeyboardEvent.KEY_DOWN, onKeyDown); 
			pinball.eventManager.registerEvent(pinball.stage, KeyboardEvent.KEY_UP, onKeyUp); 
		}
		
		private function onKeyUp(event : KeyboardEvent) : void
		{
			if(event.keyCode == LEFT)
			{
				pinball.leftDown();
			} 
			else if(event.keyCode == RIGHT)
			{
				pinball.rightDown();
			} 
			else if(event.keyCode == Keyboard.SPACE)
			{
				pinball.endStart();
			}
		}
		private function onKeyDown(event : KeyboardEvent) : void
		{
			
			if(event.keyCode == LEFT)
			{
				pinball.leftUp();
			} 
			else if(event.keyCode == RIGHT)
			{
				pinball.rightUp();
			}
			else if(event.keyCode == Keyboard.SPACE)
			{
				pinball.beginStart();
			}
			else if(event.keyCode == PUSH_LEFT)
			{
				pinball.pushLeft();
			}
			else if(event.keyCode == PUSH_RIGHT)
			{
				pinball.pushRight();
			}

		}
		
	}
}