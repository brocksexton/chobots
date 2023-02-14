package com.kavalok.admin.users.filters
{
	import com.audioo.admin.constants.TrackTypes;
	
	import flash.events.Event;
	
	import mx.controls.ComboBox;
	
	public class TypeFilterBase extends FilterBase
	{
		public var valueComboBox : ComboBox;
		
		public function TypeFilterBase()
		{
			super();
		}
		
		protected function getIndex(type : String) : Number
		{
			return TrackTypes.TYPES.indexOf(type);
		}
		protected function onValueChange(event : Event) : void
		{
			filterData.operator = 0;
			filterData.value = valueComboBox.selectedItem;
			sendChange();
		}
		
	}
}