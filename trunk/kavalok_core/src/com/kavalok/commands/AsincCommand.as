package com.kavalok.commands
{
	import com.kavalok.events.EventSender;
	
	public class AsincCommand implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(IAsincCommand);
		
		public function AsincCommand(onComplete:Function = null) 
		{
			if (onComplete != null)
				_completeEvent.addListener(onComplete);
			
		}
		
		public function execute():void
		{
		}
		
		public function cancel():void
		{
			_completeEvent.removeListeners();
		}
		
		protected function dispatchComplete():void
		{
			_completeEvent.sendEvent(this);
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
	}
}