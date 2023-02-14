package com.kavalok.gameplay
{
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.services.SystemService;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ClientTicker
	{
		static private const INTERVAL:int = 10*60*1000;
		
		private var _timer:Timer;
		
		public function ClientTicker()
		{
			_timer = new Timer(INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if (RemoteConnection.instance.connected)
			{
				new SystemService().clientTick();
			}
		}
	}
}