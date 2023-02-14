package org.goverla.controls {

	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.formatters.DateBase;
	import mx.managers.IFocusManagerComponent;

	public class DateSelectorBase extends HBox implements IFocusManagerComponent {
		
		protected static const MONTH_YEAR_STATE : String = "monthYearState";
		
		protected static const DATE_MONTH_YEAR_STATE : String = "dateMonthYearState";
		
		protected static const RANGE_START : Date = new Date(1900, 0, 1);
		
		protected static const RANGE_END : Date = new Date(2100, 11, 31);
		
		public var dayComboBox : ComboBox;
		
		[Bindable]
		public var monthComboBox : ComboBox;
		
		public var yearComboBox : ComboBox;
		
		override public function setFocus() : void {
			switch (currentState) {
				case null :
				case "" :
					yearComboBox.setFocus();
					break;
				case MONTH_YEAR_STATE :
				case DATE_MONTH_YEAR_STATE :
					monthComboBox.setFocus();
					break;
				default :
			}
		}
		
		public function get selectedDate() : Date {
			return _selectedDate;
		}
		
		public function set selectedDate(selectedDate : Date) : void {
			_selectedDate = selectedDate;
			_selectedDateChanged = true;
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
		
		[Bindable]
		public function get monthNames() : Array {
			return _monthNames;
		}
		
		public function set monthNames(monthNames : Array) : void {
			_monthNames = monthNames;
			_monthNamesChanged = true;
			invalidateProperties();
		}
		
		public function get editable() : Boolean {
			return _editable;
		}
		
		public function set editable(editable : Boolean) : void {
			_editable = editable;
			_editableChanged = true;
			invalidateProperties();
		}
		
		protected function get rangeStart() : Date {
			return (_selectableRange != null && _selectableRange.rangeStart != null ?
				_selectableRange.rangeStart : RANGE_START);
		}
		
		protected function get rangeEnd() : Date {
			return (_selectableRange != null && _selectableRange.rangeEnd != null ?
				_selectableRange.rangeEnd : RANGE_END);
		}
		
		protected function get firstYearIndex() : int {
			return rangeStart.fullYear;
		}
		
		protected function get lastYearIndex() : int {
			return rangeEnd.fullYear;
		}
		
		protected function get firstMonthIndex() : int {
			return (_selectedDate.fullYear == rangeStart.fullYear ? rangeStart.month : 0);
		}
		
		protected function get lastMonthIndex() : int {
			return (_selectedDate.fullYear == rangeEnd.fullYear ? rangeEnd.month : 11);
		}
		
		protected function get firstDayIndex() : int {
			return (_selectedDate.fullYear == rangeStart.fullYear &&
				_selectedDate.month == rangeStart.month ?
					rangeStart.date : 1);
		}
		
		protected function get lastDayIndex() : int {
			return (_selectedDate.fullYear == rangeEnd.fullYear &&
				_selectedDate.month == rangeEnd.month ?
					rangeEnd.date : getNumberOfDaysInMonth(_selectedDate.fullYear, _selectedDate.month));
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_editableChanged) {
				dayComboBox.editable = _editable;
				yearComboBox.editable = _editable;
				_editableChanged = false;
			}
			
			if (_selectableRangeChanged) {
				var years : Array = [];
				var y1 : int = firstYearIndex;
				var y2 : int = lastYearIndex;
				for (var i : int = y1; i <= y2; i++) {
					years.push({label : i, data : i});
				}
				yearComboBox.dataProvider = years;
			}
			
			if (_selectedDateChanged || _selectableRangeChanged || _monthNamesChanged) {
				_selectedDate = new Date(_selectedDate);
				if (_selectedDate < rangeStart) {
					_selectedDate = new Date(rangeStart);
					_selectedDateChanged = true;
				}
				if (_selectedDate > rangeEnd) {
					_selectedDate = new Date(rangeEnd);
					_selectedDateChanged = true;
				}

				var months : Array = [];
				var m1 : int = firstMonthIndex;
				var m2 : int = lastMonthIndex;
				for (i = m1; i <= m2; i++) {
					months.push({label : monthNames[i], data : i});
				}
				monthComboBox.dataProvider = months;

				var days : Array = [];
				var d1 : int = firstDayIndex;
				var d2 : int = lastDayIndex;
				for (i = d1; i <= d2; i++) {
					days.push({label : i, data : i});
				}
				dayComboBox.dataProvider = days;

				dayComboBox.selectedIndex = _selectedDate.date - firstDayIndex;
				monthComboBox.selectedIndex = _selectedDate.month - firstMonthIndex;
				yearComboBox.selectedIndex = _selectedDate.fullYear - firstYearIndex;

				_selectedDateChanged = false;
				_selectableRangeChanged = false;
				_monthNamesChanged = false;
			}
		}
		
		protected function onDayComboBoxChange() : void {
			if (dayComboBox.selectedItem != null) {
				commitDate(dayComboBox.selectedItem.data);
			}
		}
		
		protected function onDayComboBoxFocusOut() : void {
			commitDayComboBoxValue();
		}
		
		protected function onDayComboBoxEnter() : void {
			commitDayComboBoxValue();
		}
		
		protected function commitDayComboBoxValue() : void {
			if (dayComboBox.selectedItem == null) {
				var dayComboBoxValue : Number = Number(dayComboBox.text);
				if (!isNaN(dayComboBoxValue) && dayComboBoxValue >= firstDayIndex && dayComboBoxValue <= lastDayIndex) {
					commitDate(dayComboBoxValue);
				} else {
					commitDate(_selectedDate.date);
				}
			}
		}
		
		protected function commitDate(value : int) : void {
			_selectedDate.setDate(value);
			_selectedDateChanged = true;
			invalidateProperties();
		}
		
		protected function onMonthComboBoxChange() : void {
			commitMonth(Number(monthComboBox.selectedItem.data));
		}
		
		protected function commitMonth(value : int) : void {
			_selectedDate.setMonth(value,
				Math.min(_selectedDate.date, getNumberOfDaysInMonth(_selectedDate.fullYear, value)));
			_selectedDateChanged = true;
			invalidateProperties();
		}
		
		protected function onYearComboBoxChange() : void {
			if (yearComboBox.selectedItem != null) {
				commitYear(Number(yearComboBox.selectedItem.data));
			}
		}
		
		protected function onYearComboBoxFocusOut() : void {
			commitYearComboBoxValue();
		}
		
		protected function onYearComboBoxEnter() : void {
			commitYearComboBoxValue();
		}
		
		protected function commitYearComboBoxValue() : void {
			if (yearComboBox.selectedItem == null) {
				var yearComboBoxValue : Number = Number(yearComboBox.text)
				if (!isNaN(yearComboBoxValue) && yearComboBoxValue >= firstYearIndex && yearComboBoxValue <= lastYearIndex) {
					commitYear(yearComboBoxValue);
				} else {
					commitYear(_selectedDate.fullYear);
				}
			}
		}
		
		protected function commitYear(value : int) : void {
			_selectedDate.setFullYear(value,
				_selectedDate.month,
					Math.min(_selectedDate.date, getNumberOfDaysInMonth(value, _selectedDate.month)));
			_selectedDateChanged = true;
			invalidateProperties();
		}
		
		private function getNumberOfDaysInMonth(year : int, month : int) : int {
			var result : int;
			if (month == 1) {
				result = isLeapYear(year) ? 29 : 28;
			} else if (month == 3 || month == 5 || month == 8 || month == 10) {
				result = 30;
			} else {
				result = 31;
			}
			return result;
		}
		
		private function isLeapYear(year : int) : Boolean {
			return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
		}
		
		private var _editable : Boolean = true;
		
		private var _editableChanged : Boolean = true;
		
		private var _selectedDate : Date = new Date();
		
		private var _selectedDateChanged : Boolean = true;
		
		private var _selectableRange : Object;
		
		private var _selectableRangeChanged : Boolean = true;
		
		private var _monthNames : Array = DateBase.monthNamesLong;
		
		private var _monthNamesChanged : Boolean;
		
	}

}