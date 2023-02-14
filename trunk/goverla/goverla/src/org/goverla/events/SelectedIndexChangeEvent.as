package org.goverla.events
{
	import flash.events.Event;

	public class SelectedIndexChangeEvent extends Event
	{
		public static const SELECTED_INDEX_CHANGE : String = "selectedIndexChange";
		
		private var _oldIndex : int;
		private var _newIndex : int;
		
		public function SelectedIndexChangeEvent(oldIndex : int, newIndex : int)
		{
			super(SELECTED_INDEX_CHANGE);
			_oldIndex = oldIndex;
			_newIndex = newIndex;
		}
		
		public function get oldIndex() : int {
			return _oldIndex;
		}
		
		public function get newIndex() : int {
			return _newIndex;
		}
		
		
		
	}
}