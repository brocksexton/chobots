package common.events
{
	import common.utils.ArrayUtil;
	import flash.events.Event;
	
	public class EventSender
	{
		private var _listeners:Array = [];
		private var _sender:Object;
		
		public function EventSender(sender:Object)
		{
			_sender = sender;
		}
		
		public function addListener(listener:Function):void
		{
			if (hasListener(listener))
				throw new Error("List already contains such listener");
			else
				_listeners.push(listener);
		}
		
		public function removeListener(listener:Function):void
		{
			if (hasListener(listener))
				ArrayUtil.removeItem(_listeners, listener);
			else
				throw new Error("List doesn't contains such listener");
		}
		
		public function sendEvent():void
		{
			var handlers:Array = _listeners.slice();
			
			for each (var handler:Function in handlers)
			{
				handler(_sender);
			}
		}

		public function hasListener(func:Function):Boolean
		{
			return _listeners.indexOf(func) >= 0;
		}
	}
}