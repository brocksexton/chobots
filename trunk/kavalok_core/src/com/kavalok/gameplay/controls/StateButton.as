package com.kavalok.gameplay.controls
{
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class StateButton
	{
		private var _content:MovieClip;
		private var _stateEvent:EventSender = new EventSender();
		private var _changeState:Boolean;
		
		public function StateButton(content:MovieClip, changeState : Boolean = true)
		{
			_content = content;
			_changeState = changeState;
			_content.buttonMode = true;
			_content.stop();
			_content.doubleClickEnabled = true;
			_content.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(_changeState)
			{
				if (_content.currentFrame == _content.totalFrames)
					_content.gotoAndStop(1);
				else
					_content.gotoAndStop(_content.currentFrame + 1);
			}
				
			stateEvent.sendEvent(this);
		}
		
		public function get state():int
		{
			 return _content.currentFrame;
		}
		
		public function set state(value:int):void
		{
			 _content.gotoAndStop(value);
		}
		
		public function get stateEvent():EventSender { return _stateEvent; }
	}
}