package com.kavalok.admin.controls
{
	import mx.containers.HBox;

	public class DateRangeChooserBase extends HBox
	{
		[Bindable]
		public var from : Date;
		[Bindable]
		public var to : Date;
		
		public function DateRangeChooserBase()
		{
			super();
		}
		
		protected function get tomorrow() : Date
		{
			var date : Date = new Date();
			date.setDate(date.date + 1);
			return date;
		}
		protected function get yesterday() : Date
		{
			var date : Date = new Date();
			date.setDate(date.date - 1);
			return date;
		}
	}
}