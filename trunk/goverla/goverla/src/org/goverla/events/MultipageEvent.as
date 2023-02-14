package org.goverla.events {
	
	import flash.events.Event;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class MultipageEvent extends Event {
		
		public static var ITEMS_TOTAL_CHANGE : String = "itemsTotalChange";
		
		public static var PAGES_TOTAL_CHANGE : String = "pagesTotalChange";
		
		public static var CURRENT_PAGE_CHANGE : String = "currentPageChange";
		
		public function MultipageEvent(type : String) {
			super(type);
		}
		
		public override function clone() : Event {
			return new MultipageEvent(type);
		}
	
	}

}