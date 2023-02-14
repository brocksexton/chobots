package com.kavalok.text
{
	import flash.text.TextField;
	
	import com.kavalok.events.EventSender;
	import com.kavalok.flash.process.EnterFrameTimer;
	
	public class TextPlayer
	{
		private static const FRAMES_PER_TICK : uint = 1;

		private var _textField : TextField;
		private var _currentText : String;
		private var _parts : Array;

		private var _change : EventSender = new EventSender();
		private var _finish : EventSender = new EventSender();
		private var _timer : EnterFrameTimer;
		
		
		public function TextPlayer(textField : TextField)
		{
			_textField = textField;
			_timer = new EnterFrameTimer(FRAMES_PER_TICK, _textField);
			_timer.tick.addListener(onTick);
		}
		
		public function get finish() : EventSender
		{
			return _finish;
		}
		public function get change() : EventSender
		{
			return _change;
		}
		
		public function stop() : void
		{
			_timer.stop();
		}
		public function playParts(parts : Array) : void
		{
			stop();
			_parts = parts;
			_currentText = "";
			_textField.text = "";
			_timer.start();
			
		}
		public function play(text : String) : void
		{
			playParts(text.split(""));
		}

		private function onTick() : void
		{
			var part : String = _parts.shift();
			if(part)
			{
				if(part == "\n")
					part = "<br>";
				_currentText += part;
				_textField.htmlText = _currentText;
				_textField.scrollV = _textField.maxScrollV;
				change.sendEvent();
			}
			if(_parts.length == 0)
			{
				finish.sendEvent();
				stop();
			}
		}
	}
}