package com.kavalok.gameplay.controls
{
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class InputText
	{
		static private const EMPTY_COLOR:int = 0xAAAAAA;
		static private const BLINK_COLOR:int = 0xFF0000;
		
		private var _field:TextField;
		private var _isEmpty:Boolean = true;
		private var _emptyText:String = "inputText";
		private var _blinkTimer:Timer;
		private var _backColor:int;
		
		public function InputText(field:TextField)
		{
			_field = field;
			_field.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_field.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_field.text = '';
			
			setEmptyText();
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			if (_isEmpty)
			{
				_isEmpty = false;
				resetEmptyText();
			}
		}
				
		private function onFocusOut(e:FocusEvent):void
		{
			_isEmpty = (value == '');
			 if (_isEmpty)
			 	setEmptyText();
		}
		
		public function set emptyText(value:String):void
		{
			 _emptyText = value;
			 if (_isEmpty)
			 	setEmptyText();
		}
		
		public function blink():void
		{
			if (_blinkTimer)
				return;
				
			_backColor = _field.backgroundColor;
			_blinkTimer = new Timer(200, 4);
			_blinkTimer.addEventListener(TimerEvent.TIMER, onBlink);
			_blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopBlink);
			_blinkTimer.start();
		}
		
		private function onBlink(e:TimerEvent):void
		{
			if (isEmpty)
			{
				_field.backgroundColor = (_field.backgroundColor == _backColor)
					? BLINK_COLOR
					: _backColor;
			}
			else
			{
				stopBlink();
			}
		}
		
		private function stopBlink(e:Event = null):void
		{
			if (_blinkTimer)
			{
				_blinkTimer.stop();
				_blinkTimer = null;
			}
		}
		
		private function setEmptyText():void
		{
			_field.text = _emptyText;
			var format:TextFormat = _field.getTextFormat();
			format.color = EMPTY_COLOR;
			_field.setTextFormat(format);
		}
		
		private function resetEmptyText():void
		{
			_field.text = "";
			var format:TextFormat = _field.getTextFormat();
			format.color = 0x000000;
			_field.setTextFormat(format);
		}
		
		public function get field():TextField
		{
			 return _field;
		}
		
		public function get value():String
		{
			return (_isEmpty) ? '' : Strings.trim(_field.text);
		}
		
		public function get isEmpty():Boolean
		{
			 return _isEmpty;
		}

	}
}