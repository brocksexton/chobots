package com.kavalok.admin.users.filters
{
	import flash.events.Event;
	
	import mx.controls.TextInput;
	import mx.utils.StringUtil;
	
	import org.goverla.utils.Strings;
	
	public class StringFilterBase extends FilterBase
	{
		private static const FORMAT : String = "{0}%";
		public var valueTextInput : TextInput;
		
		public function StringFilterBase()
		{
			super();
		}
		
		protected function onValueChange(event : Event) : void
		{
			var value : String = Strings.removeSymbols(valueTextInput.text, "%");
			if(value.indexOf('_')!=0){
				filterData.value =  StringUtil.substitute(FORMAT, value.toLowerCase());
				filterData.operator = "like";
			}else{
				filterData.value =  value.toLowerCase();
				filterData.operator = "=";
			}
			sendChange();
		}
		
		protected function removeSymbols(value : String) : String
		{
			return Strings.trimSymbols(value, "%");
		}
		
		
	}
}