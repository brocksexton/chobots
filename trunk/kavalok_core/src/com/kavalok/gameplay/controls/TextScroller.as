package com.kavalok.gameplay.controls
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class TextScroller extends Scroller
	{
		private var _textField : TextField;
		private var _locked:Boolean = true;
		
		public function TextScroller(content:MovieClip, textField : TextField)
		{
			_textField = textField;
			super(content);
			_textField.addEventListener(Event.CHANGE, onTextChange);
			_textField.addEventListener(Event.SCROLL, onTextScroll);
			changeEvent.addListener(onChange);
			updateScrollerVisible();
		}
		
		override public function set position(value:Number):void
		{
			super.position = value;
			updateTextField();
		}
		
		public function updateScrollerVisible() : void
		{
			scrollerVisible = _textField.textHeight > _textField.height;
		}
		
		public function updateTextField() : void
		{
			_locked = true;
			_textField.scrollV = _textField.maxScrollV * position;
			_locked = false;
		}

		private function onTextScroll(event : Event) : void
		{
			if (!_locked)
				super.position = (_textField.scrollV - 1) / (_textField.maxScrollV - 1);
		}

		private function onTextChange(event : Event) : void
		{
			updateScrollerVisible();
		}
		
		private function onChange(scroller : TextScroller) : void
		{
			updateTextField();
		}
		
		
		
	}
}