package com.kavalok.admin.users.filters
{
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	
	public class BooleanFilterBase extends FilterBase
	{
		public var valueCheckBox : CheckBox;
		
		public function BooleanFilterBase()
		{
			super();
		}
		
		protected function onValueChange(event : Event) : void
		{
			filterData.value = valueCheckBox.selected;
			sendChange();
		}
		
	}
}