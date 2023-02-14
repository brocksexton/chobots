package com.kavalok.utils
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class IdleManager
	{

		static private const TIMEOUT:int = 30 * 60; //seconds
		
		private var timer:Timer;
		
		
		public function IdleManager()
		{
			timer = new Timer(TIMEOUT * 1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			RemoteConnection.instance.connectEvent.addListener(start);
			RemoteConnection.instance.disconnectEvent.addListener(stop);
			
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE, reset);
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, reset);
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, reset);
		}
		
		public function start():void
		{
			timer.start();
		}
		
		public function reset(e:Event):void
		{
			if (timer.running)
			{
				timer.reset();
				timer.start();
			}
		}
		
		private function stop():void
		{
			timer.stop();
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{

			if (!Global.charManager.isModerator)
			{
				RemoteConnection.instance.disconnect();
				Dialogs.showOkDialog(Global.messages.idleTimeout, false);
			}
			else {
				Dialogs.showOkDialog("You're not being active in-game. Please logout if you're not going to interact.");

			}

		}

	}
}