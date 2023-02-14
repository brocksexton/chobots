package com.kavalok.admin.controls
{
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.DateChooser;

	[Event(name="change")]
	public class DateTimeChooserBase extends HBox
	{
		public var dateChooser : DateChooser;
		public var hoursComboBox : ComboBox;
		
		[Bindable]
		protected var hours : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];
		
		public function DateTimeChooserBase()
		{
			super();
		}
		
		[Bindable(event="change")]
		public function get value() : Date
		{
			if(dateChooser && hoursComboBox)
			{
				var result : Date = dateChooser.selectedDate;
				result.hours = Number(hoursComboBox.value);
				result.minutes = 0;
				result.seconds = 0;
				result.milliseconds = 0;
				return result;
			}
			return null;
		}
		
	}
}