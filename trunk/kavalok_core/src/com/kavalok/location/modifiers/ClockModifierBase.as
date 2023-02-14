package com.kavalok.location.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.utils.DateUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class ClockModifierBase
	{
		static private const UPDATE_INTERVAL:int = 5; // seconds
		
		private var _content:Sprite;
		private var _timer:Timer = new Timer(1000 * UPDATE_INTERVAL);
		private var _time:Date;
		
		public function ClockModifierBase(content:Sprite)
		{
			_content = content;
			_content.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			onTimer();
		}
		
		private function onTimer(e:TimerEvent = null):void
		{
			_time = Global.getServerTime();
			updateClock();
		}
		
		protected function updateClock():void
		{
			throw new NotImplementedError();
		}
		
		protected function dispose(e:Event = null):void
		{
			_timer.stop();
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		public function get hours():Number
		{
			 return _time.hours;
		}
		
		public function get minutes():Number
		{
			 return _time.minutes;
		}
		
		public function get seconds():Number
		{
			 return _time.seconds;
		}
		
		public function get date():String
		{
			var text:String = DateUtil.toString(_time);
			text = text.substr(0, 6) + text.substr(8); 
			return text;
		}
	}
}