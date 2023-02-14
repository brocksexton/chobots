package com.kavalok.gameplay.controls
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ButtonBase
	{
		public var highliteOnOver : Boolean = true;
		protected var over : Boolean;

		private var _content : MovieClip;

		public function ButtonBase(content : MovieClip)
		{
			_content = content;
			_content.mouseChildren = false;
			_content.useHandCursor = true;
			_content.buttonMode = true;
			_content.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_content.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_content.gotoAndStop(1);
		}

		public function get content() : MovieClip
		{
			return _content;
		}
		
		private function onRollOver(event : MouseEvent) : void
		{
			over = true;
			invalidate();
		}
		
		private function onRollOut(event : MouseEvent) : void
		{
			over = false;
			invalidate();
		}
		
		protected function invalidate() : void
		{
			if(over && highliteOnOver)
			{
				_content.gotoAndStop(2);
				_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				_content.gotoAndStop(1);
				if(_content.hasEventListener(Event.ENTER_FRAME))
				{
					_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		protected function onEnterFrame(event : Event) : void
		{
			if(_content.stage == null)
			{
				_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			if(!_content.hitTestPoint(_content.stage.mouseX, _content.stage.mouseY))
			{
				onMouseOut();
			}
		}
		
		protected function onMouseOut() : void
		{
			over = false;
			invalidate();
		}
		
	}
}