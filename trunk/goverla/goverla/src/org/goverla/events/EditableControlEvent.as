package org.goverla.events {

	import flash.events.Event;

	public class EditableControlEvent extends Event {
		
		public static const SUBMIT_EDITED_VALUE : String = "submitEditedValue";
		
		public static const CANCEL_EDITED_VALUE : String = "cancelEditedValue";
		
		public static const SAVE : String = "save";
		
		public static const SAVE_FAULT : String = "saveFault";
		
		public static const HIDE_EMPTY_CHANGE : String = "hideEmptyChange";
		
		public static const HIDE_EMPTY_PARENT_FORM_ITEM_CHANGE : String = "hideEmptyParentFormItemChange";
		
		public static const VIEW_CONTROL_VALUE_COMMIT : String = "viewControlValueCommit";
		
		public function EditableControlEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}

}