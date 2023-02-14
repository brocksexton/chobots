package com.kavalok.admin.users.filters
{
	import com.audioo.admin.data.FilterData;
	
	import flash.events.Event;
	
	import mx.controls.DateChooser;
	import mx.events.FlexEvent;
	
	import org.goverla.utils.Objects;
	
	public class DateFilterBase extends OperatorFilterBase
	{
		protected static const OPEN_STATE : String = "openState";
		
		[Bindable]
		public var dateChooser : DateChooser;
		
		public function DateFilterBase()
		{
			super();
		}
		
		protected function onInitialize(event : FlexEvent) : void
		{
			if(filterData.value == null)
			{
				filterData.value = new Date();
			}
		}
		
		protected function getValue(data : FilterData) : Date
		{
			if(data.value == null)
			{
				data.value = new Date();
			}
			return Objects.castToDate(data.value);
		}
		
		protected function onDateChange(event : Event) : void
		{
			currentState = "";
			filterData.value = dateChooser.selectedDate;
			sendChange();
		}
		
		
	}
}