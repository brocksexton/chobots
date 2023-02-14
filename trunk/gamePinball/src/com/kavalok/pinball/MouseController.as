package com.kavalok.pinball
{
	import flash.events.MouseEvent;
	
	import com.kavalok.utils.Timers;
	
	public class MouseController extends PinballControllerBase
	{
		private static const PAUSE : Number = 300;
		private static const OFFSET : Number = 10;
		
		private var _previousPosition : Number;
		
		public function MouseController(pinball:GamePinball)
		{
			super(pinball);
			pinball.content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			pinball.content.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			pinball.content.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseUp(event : MouseEvent) : void
		{
			pinball.endStart();
		}
		private function onMouseDown(event : MouseEvent) : void
		{
			pinball.beginStart();
		}
		
		private function onMouseMove(event : MouseEvent) : void
		{
			var offset : Number = event.stageX - _previousPosition;
			if(Math.abs(offset) >= OFFSET)
			{
				if(event.buttonDown)
				{
					if(offset > 0)
					{
						pinball.pushLeft();
					}
					else
					{
						pinball.pushRight();
					}
					
				}
				else
				{
					if(offset > 0)
					{
						pinball.rightUp();
						pinball.leftDown();
						Timers.callAfter(pinball.rightDown, PAUSE);
					}
					else
					{
						Timers.callAfter(pinball.leftDown, PAUSE);
						pinball.rightDown();
						pinball.leftUp();
					}
				}
			}
			_previousPosition = event.stageX;
		}
		
		
		
		
	}
}