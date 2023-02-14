package com.kavalok.gameplay.controls
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.kavalok.events.EventSender;
	
	public class Spinner
	{
		private var _increment:Number = 1;
		
		private var _content:Sprite;
		private var _field:TextField;
		private var _btnUp:SimpleButton;
		private var _btnDown:SimpleButton;
		
		private var _minValue:Number = -Number.MIN_VALUE;
		private var _maxValue:Number = Number.MAX_VALUE;
		private var _value:Number = 0;
		
		private var _changeEvent:EventSender = new EventSender();
		
		public function Spinner(content:MovieClip)
		{
			_content = content;
			_field = content.txtValue;
			_btnUp = content.btnUp;
			_btnDown = content.btnDown;
			
			_btnUp.addEventListener(MouseEvent.CLICK, onUpClick);
			_btnDown.addEventListener(MouseEvent.CLICK, onDownClick);
			
			refresh();
		}
		
		private function onUpClick(e:MouseEvent):void
		{
			_value += _increment;
			refresh();
			_changeEvent.sendEvent(this);
		}
		
		private function onDownClick(e:MouseEvent):void
		{
			_value -= _increment;
			refresh();
			_changeEvent.sendEvent(this);
		}
		
		public function get value():Number { return _value; }
		public function set value(v:Number):void
		{
			_value = v;
			refresh();
		}
		
		public function get increment():Number { return _increment; }
		public function set increment(v:Number):void
		{
			_increment = v;
		}
		
		public function get maxValue():Number { return _maxValue; }
		public function set maxValue(v:Number):void
		{
			_maxValue = v;
			refresh();
		}
		
		public function get minValue():Number { return _minValue; }
		public function set minValue(v:Number):void
		{
			_minValue = v;
			refresh();
		}
		
		private function refresh():void
		{
			_value = GraphUtils.claimRange(_value, _minValue, _maxValue);
			_field.text = _value.toString();
			
			GraphUtils.setBtnEnabled(_btnUp, _value < _maxValue);
			GraphUtils.setBtnEnabled(_btnDown, _value > _minValue);
		}
		
		public function get content():Sprite
		{
			 return _content;
		}

		public function get changeEvent():EventSender { return _changeEvent; }
	}
}