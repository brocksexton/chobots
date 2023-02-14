package org.goverla.controls.editable {

	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.DateChooserEvent;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateBase;
	
	import org.goverla.controls.editable.common.EditableLabel;
	import org.goverla.utils.EventRedispatcher;
	
	[Event(name="change", type="mx.events.CalendarLayoutChangeEvent")]
	
	[Event(name="close", type="mx.events.DropdownEvent")]
	
	[Event(name="open", type="mx.events.DropdownEvent")]
	
	[Event(name="scroll", type="mx.events.DateChooserEvent")]
	
	public class DateFieldLabel extends EditableLabel {
		
		protected static const DEFAULT_SERVER_DATE_FORMAT_STRING : String = "YYYY.MM.DD";
		
		public function DateFieldLabel() {
			super();

			new EventRedispatcher(this).facadeEvents(editDateField, CalendarLayoutChangeEvent.CHANGE, DropdownEvent.OPEN, DropdownEvent.CLOSE, DateChooserEvent.SCROLL, FlexEvent.VALUE_COMMIT);
		}
		
		override public function get value() : Object {
			return DateField.dateToString(selectedDate, DEFAULT_SERVER_DATE_FORMAT_STRING);
		}
		
		override public function set value(value : Object) : void {
			selectedDate = (value != null ?
				DateField.stringToDate(String(value), DEFAULT_SERVER_DATE_FORMAT_STRING) :
					null);
		}
		
		public function get selectedDate() : Date {
			return _selectedDate;
		}
		
		public function set selectedDate(selectedDate : Date) : void {
			_selectedDate = selectedDate;
			_selectedDateChanged = true;
			invalidateProperties();
		}
		
		public function get monthNames() : Array {
			return _monthNames;
		}
		
		public function set monthNames(monthNames : Array) : void {
			_monthNames = monthNames;
			_monthNamesChanged = true;
			invalidateProperties();
		}
		
		public function get selectableRange() : Object {
			return _selectableRange;
		}
		
		public function set selectableRange(selectableRange : Object) : void {
			_selectableRange = selectableRange;
			_selectableRangeChanged = true;
			invalidateProperties();
		}
		
		public function get yearNavigationEnabled() : Boolean {
			return _yearNavigationEnabled;
		}
		
		public function set yearNavigationEnabled(yearNavigationEnabled : Boolean) : void {
			_yearNavigationEnabled = yearNavigationEnabled;
			_yearNavigationEnabledChanged = true;
			invalidateProperties();
		}
		
		public function get dateFieldEditable() : Boolean {
			return _dateFieldEditable;
		} 
		
		public function set dateFieldEditable(dateFieldEditable : Boolean) : void {
			_dateFieldEditable = dateFieldEditable;
			_dateFieldEditableChanged = true;
			invalidateProperties();
		} 
		
		protected final function get editDateField() : DateField {
			return DateField(editControl);
		}
		
		override protected function createChildren() : void {
			super.createChildren();
			
			editControl = new DateField();
			editDateField.percentWidth = 100;
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_selectedDateChanged) {
				editDateField.selectedDate = _selectedDate;
				viewLabel.text = dateToString(_selectedDate);
				_selectedDateChanged = false;
			}
			
			if (_monthNamesChanged) {
				editDateField.monthNames = _monthNames;
				_monthNamesChanged = false;
			}
			
			if (_selectableRangeChanged) {
				editDateField.selectableRange = _selectableRange;
				_selectableRangeChanged = false;
			}
			
			if (_yearNavigationEnabledChanged)  {
				editDateField.yearNavigationEnabled = _yearNavigationEnabled;
				_yearNavigationEnabledChanged = false;
			}
			
			if (_dateFieldEditableChanged) {
				editDateField.editable = _dateFieldEditable;
				_dateFieldEditableChanged = false;
			}
		}
		
		override protected function submitEditedValue() : void {
			selectedDate = editDateField.selectedDate;
			super.submitEditedValue();
		}
		
		override protected function cancelEditedValue() : void {
			selectedDate = _selectedDate;
			super.cancelEditedValue();
		}
		
		override protected function onEditState() : void {
			editDateField.setFocus();
			if (fullEditState) {
				editDateField.open();
			}
		}
		
		private function dateToString(date : Date) : String {
			var result : String =
				(editDateField.labelFunction != null) ?
					editDateField.labelFunction(date) :
						DateField.dateToString(date, editDateField.formatString);
			return result;
		}
		
		private var _selectedDate : Date = new Date();
		
		private var _selectedDateChanged : Boolean = true;
		
		private var _monthNames : Array = DateBase.monthNamesLong;
		
		private var _monthNamesChanged : Boolean;
		
		private var _selectableRange : Object;
		
		private var _selectableRangeChanged : Boolean;
		
		private var _yearNavigationEnabled : Boolean;
		
		private var _yearNavigationEnabledChanged : Boolean;
		
		private var _dateFieldEditable : Boolean;
		
		private var _dateFieldEditableChanged : Boolean;
		
	}

}