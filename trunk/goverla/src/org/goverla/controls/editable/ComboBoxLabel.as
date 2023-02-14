package org.goverla.controls.editable {

	import flash.events.Event;
	
	import mx.controls.ComboBox;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	
	import org.goverla.controls.editable.common.EditableLabel;
	import org.goverla.interfaces.IBindableList;
	import org.goverla.utils.EventRedispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	
	[Event(name="open", type="mx.events.DropdownEvent")]
	
	[Event(name="close", type="mx.events.DropdownEvent")]
	
	[Event(name="enter", type="mx.events.FlexEvent")]
	
	[Event(name="scroll", type="mx.events.ScrollEvent")]
	
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	
	public class ComboBoxLabel extends EditableLabel implements IBindableList {
		
		private var _selectedIndex : int;

		public function ComboBoxLabel() {
			super();

			editControl = new ComboBox();

			new EventRedispatcher(this).facadeEvents(editComboBox, Event.CHANGE, DropdownEvent.OPEN, DropdownEvent.CLOSE, FlexEvent.ENTER, ScrollEvent.SCROLL, ListEvent.ITEM_ROLL_OVER, ListEvent.ITEM_ROLL_OUT);
		}
		
		public function get dataProvider() : Object {
			return editComboBox.dataProvider;
		}
		
		public function set dataProvider(dataProvider : Object) : void {
			editComboBox.dataProvider = dataProvider;
			viewLabel.text = editComboBox.itemToLabel(dataProvider[0]);
		}
		
		[Bindable]
		public function get selectedIndex() : int {
			return editComboBox.selectedIndex;
		}
		
		public function set selectedIndex(selectedIndex : int) : void {
			editComboBox.selectedIndex = selectedIndex;
			changeSelectedIndex();
		}
		
		[Bindable]
		public function get selectedItem() : Object {
			return editComboBox.selectedItem;
		}
		
		public function set selectedItem(selectedItem : Object) : void {
			editComboBox.selectedItem = selectedItem;
			changeSelectedIndex();
		}
		
		public function get selectedLabel() : String {
			return editComboBox.selectedLabel;
		}
		
		public function get labelField() : String {
			return editComboBox.labelField;
		}
		
		public function set labelField(labelField : String) : void {
			editComboBox.labelField = labelField;
		}
		
		public function get prompt() : String {
			return editComboBox.prompt;
		}
		
		public function set prompt(prompt : String) : void {
			editComboBox.prompt = prompt;
		}
		
		public function get rowCount() : int {
			return editComboBox.rowCount;
		}
		
		public function set rowCount(rowCount : int) : void {
			editComboBox.rowCount = rowCount;
		}
		
		protected function get editComboBox() : ComboBox {
			return ComboBox(editControl);
		}
		
		protected override function submitEditedValue() : void {
			changeSelectedIndex();

			super.submitEditedValue();
		}
		
		protected override function cancelEditedValue() : void {
			editComboBox.selectedIndex = _selectedIndex;
			super.cancelEditedValue();
		}
		
		protected override function onEditState() : void {
			editComboBox.setFocus();
			if (fullEditState) {
				editComboBox.open();
			}
		}
		
		private function changeSelectedIndex() : void {
			_selectedIndex = editComboBox.selectedIndex;
			viewLabel.text = editComboBox.itemToLabel(editComboBox.selectedItem);
		}
		
	}

}