package com.kavalok.location.modifiers
{
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	
	public class DigitalClockModifier extends ClockModifierBase
	{
		public static const PREFIX : String = "digitalClock";
		
		private var _dateTimer:Timer = new Timer(10 * 1000);
		private var _alpha:int = 1;
		
		public function DigitalClockModifier(content:Sprite)
		{
			super(content);
			
			_dateTimer.addEventListener(TimerEvent.TIMER, changeDateTime);
			_dateTimer.start();
			dateClip.alpha = 0;
		}
		
		private function changeDateTime(e:TimerEvent):void
		{
			_alpha = 1 - _alpha;
			
			new SpriteTweaner(timeClip, {alpha: _alpha}, 10);
			new SpriteTweaner(dateClip, {alpha: 1 - _alpha}, 10);
		}
		
		override protected function updateClock():void
		{
			hoursField.text = (hours >= 10 ? '' : '0') + hours;
			minutesField.text = (minutes >= 10 ? '' : '0') + minutes;
			dateField.text = date;
		}
		
		override protected function dispose(e:Event = null):void
		{
			super.dispose();
			_dateTimer.stop();
		}
		
		public function get dateField():TextField
		{
			 return dateClip['dateField'];
		}
		
		public function get minutesField():TextField
		{
			 return timeClip['minutesField'];
		}
		
		public function get hoursField():TextField
		{
			 return timeClip['hoursField'];
		}
		
		public function get timeClip():Sprite
		{
			 return content['timeClip'];
		}
		
		public function get dateClip():Sprite
		{
			 return content['dateClip'];
		}
	}
}