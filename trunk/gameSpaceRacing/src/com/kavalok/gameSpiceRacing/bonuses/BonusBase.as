package com.kavalok.gameSpiceRacing.bonuses
{
	import com.kavalok.gameSpiceRacing.Player;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BonusBase
	{
		public var player:Player;
		
		private var _timer:Timer;
		
		/**
		 * get duration in seconds
		 */
		public function get time():int
		{
			return 0;
		}
		
		public function apply():void
		{
		}
		
		public function restore():void
		{
		}
		
		public function execute():void
		{
			apply();
			
			if (time > 0)
			{
				_timer = new Timer(1000 * time, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.start();
			}
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			destroy();
		}
		
		public function destroy():void
		{
			restore();
			
			if (_timer)
				_timer.stop();
		}
	}
	
}
