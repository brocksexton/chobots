package org.goverla.utils.timers {
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.goverla.interfaces.ICommand;

	public class CallFunctionAction implements ICommand	{
		
		private var _timer : Timer;
		private var _function : Function;
		private var _args : Array;
		private var _thisObject : Object;
		
		public function CallFunctionAction(func : Function, delay : uint = 100, thisObject : Object = null, args : Array = null)
		{
			_timer = new Timer(delay, 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_function = func;
			_args = args;
			_thisObject = thisObject;
		}
		
		public function execute():void
		{
			_timer.start();
		}
		
		private function onTimer(timer : TimerEvent) : void
		{
			if(_args == null && _thisObject == null)
			{
				_function();
			}
			else
			{
				_function.apply(_thisObject, _args);
			}
		}
		
	}
}