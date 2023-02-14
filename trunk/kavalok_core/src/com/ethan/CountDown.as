package com.ethan
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.kavalok.Global;
	
	public class CountDown extends EventDispatcher
	{
		public static const MILLISECONDS_PER_MINUTE:int = 1000 * 60;
		public static const MILLISECONDS_PER_HOUR:int = 1000 * 60 * 60;
		public static const MILLISECONDS_PER_DAY:int = 1000 * 60 * 60 * 24;
		public var ticker:Timer = new Timer(1000);		
		private var _targetDate:Date;
		
		public function init( date:Date ) : void
		{
			_targetDate = date; 
			ticker.addEventListener(TimerEvent.TIMER, _onTick);
	        ticker.start();
		}
		
		public function stop():void
		{
		ticker.stop();
        ticker.removeEventListener(TimerEvent.TIMER, _onTick);
		}
		
		private function _onTick(event:TimerEvent):void 
    	{
			var targetMillisecs:Number = _targetDate.valueOf();
			
			var date:Date = Global.getServerTime();
			var currentMillisecs:Number = Math.round(date.valueOf());
			
			var diff:Number = (targetMillisecs - currentMillisecs);
			
			if (diff < 0) diff = 0;
		
			dispatchEvent( new CountDownEvent( CountDownEvent.UPDATE , diff ) );
    	}
	}
}