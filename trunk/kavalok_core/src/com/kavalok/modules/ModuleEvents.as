package com.kavalok.modules
{
	import com.kavalok.events.EventSender;
	
	public class ModuleEvents
	{
		private var _loadEvent : EventSender = new EventSender();
		private var _destroyEvent : EventSender = new EventSender();
		private var _abortEvent : EventSender = new EventSender();
		public function ModuleEvents()
		{
		}
		
		public function get loadEvent() : EventSender
		{
			return _loadEvent;
		}
		public function get abortEvent() : EventSender
		{
			return _abortEvent;
		}
		public function get destroyEvent() : EventSender
		{
			return _destroyEvent;
		}

	}
}