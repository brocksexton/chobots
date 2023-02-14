package com.kavalok.admin.users.filters
{
	import flash.events.Event;
	
	import mx.controls.TextInput;

	public class NumberFilterBase extends FilterBase
	{
		public var valueTextInput : TextInput;

		public function NumberFilterBase()
		{
			super();
		}

		protected function onValueChange(event:Event):void
		{
			filterData.value=valueTextInput.text;
			sendChange();
		}

	}
}

