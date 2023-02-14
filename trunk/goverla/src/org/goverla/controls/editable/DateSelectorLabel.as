package org.goverla.controls.editable {

	import mx.controls.DateField;
	import mx.formatters.DateBase;
	
	import org.goverla.controls.DateSelector;
	import org.goverla.controls.editable.common.EditableLabel;

	public class DateSelectorLabel extends EditableLabel {

		protected static const DEFAULT_SERVER_DATE_FORMAT_STRING : String = "YYYY.MM.DD";
		
		protected static const DEFAULT_CLIENT_DATE_FORMAT_STRING : String = "MM/DD/YYYY";

		public function DateSelectorLabel() {
			super();
			
			editControl = new DateSelector();
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
		
		public function get dateSelectorEditable() : Boolean {
			return _dateSelectorEditable;
		}
		
		public function set dateSelectorEditable(dateSelectorEditable : Boolean) : void {
			_dateSelectorEditable = dateSelectorEditable;
			_dateSelectorEditableChanged = true;
			invalidateProperties();
		}
		
		protected final function get editDateSelector() : DateSelector {
			return DateSelector(editControl);
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_selectedDateChanged) {
				editDateSelector.selectedDate = _selectedDate;
				viewLabel.text = dateToString(_selectedDate);
				_selectedDateChanged = false;
			}
			
			if (_monthNamesChanged) {
				editDateSelector.monthNames = _monthNames;
				_monthNamesChanged = false;
			}
			
			if (_selectableRangeChanged) {
				editDateSelector.selectableRange = _selectableRange;
				_selectableRangeChanged = false;
			}
			
			if (_dateSelectorEditable) {
				editDateSelector.editable = _dateSelectorEditable;
				_dateSelectorEditableChanged = false;
			}
		}
		
		override protected function submitEditedValue() : void {
			selectedDate = editDateSelector.selectedDate;
			super.submitEditedValue();
		}
		
		override protected function cancelEditedValue() : void {
			selectedDate = _selectedDate;
			super.cancelEditedValue();
		}
		
		override protected function onEditState() : void {
			editDateSelector.setFocus();
		}
		
		private function dateToString(date : Date) : String {
			return DateField.dateToString(date, DEFAULT_CLIENT_DATE_FORMAT_STRING);
		}
		
		private var _selectedDate : Date = new Date();
		
		private var _selectedDateChanged : Boolean = true;
		
		private var _monthNames : Array = DateBase.monthNamesLong;
		
		private var _monthNamesChanged : Boolean;
		
		private var _selectableRange : Object;
		
		private var _selectableRangeChanged : Boolean;
		
		private var _dateSelectorEditable : Boolean;
		
		private var _dateSelectorEditableChanged : Boolean;
		
	}

}