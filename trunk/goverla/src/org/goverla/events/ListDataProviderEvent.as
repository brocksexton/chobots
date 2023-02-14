package org.goverla.events {

	import flash.events.Event;

	public class ListDataProviderEvent extends Event {

		public static const ADD : String = "listDataProviderAdd";
		
		public static const ADD_FAULT : String = "listDataProviderAddFault";
		
		public static const REMOVE : String = "listDataProviderRemove";
		
		public static const REMOVE_FAULT : String = "listDataProviderRemoveFault";
		
		public static const EDIT : String = "listDataProviderEdit";
		
		public static const EDIT_FAULT : String = "listDataProviderEditFault";
		
		public static const REFRESH : String = "listDataProviderRefresh";
		
		public static const REFRESH_FAULT : String = "listDataProviderRefreshFault";
		
		public function ListDataProviderEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event {
			return new ListDataProviderEvent(type, bubbles, cancelable);
		}

	}

}