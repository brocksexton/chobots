package com.kavalok.gameplay.controls
{
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class CheckBox
	{
		private var _content:MovieClip
		private var _clickEvent:EventSender = new EventSender(CheckBox);
		
		public function CheckBox(content:MovieClip)
		{
			_content = content;
			_content.buttonMode = true;
			_content.addEventListener(MouseEvent.CLICK, onClick);
			checked = false;
		}
		
		private function onClick(e:MouseEvent):void
		{
			checked = !checked;
			_clickEvent.sendEvent(this);
		}
		
		public function get checked():Boolean
		{
			 return _content.currentFrame == 2;
		}
		
		public function set checked(value:Boolean):void
		{
			 _content.gotoAndStop(value ? 2 : 1);
		}
		
		public function get content():MovieClip { return _content; }
		public function get clickEvent():EventSender { return _clickEvent; }

	}
}