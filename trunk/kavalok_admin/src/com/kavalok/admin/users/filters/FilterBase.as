package com.kavalok.admin.users.filters
{
	import com.kavalok.dto.admin.FilterTO;
	
	import mx.containers.HBox;
	
	import org.goverla.events.EventSender;
	import org.goverla.events.TargetEvent;
	
	public class FilterBase extends HBox
	{
		[Bindable]
		public var filterData : FilterTO;
		
		
		private var _remove : EventSender = new EventSender(TargetEvent);
		private var _change : EventSender = new EventSender();
		
		public function FilterBase()
		{
			super();
		}
		
		public function get remove() : EventSender
		{
			return _remove;
		}		
		
		public function get change() : EventSender
		{
			return _change;
		}		
		
		protected function sendRemove() : void
		{
			remove.sendEvent(new TargetEvent(this));
		}
		
		protected function sendChange() : void
		{
			change.sendEvent();
		}

	}
}