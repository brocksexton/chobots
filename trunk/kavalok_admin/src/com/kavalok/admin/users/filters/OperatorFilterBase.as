package com.kavalok.admin.users.filters
{
	import com.audioo.admin.data.Operator;
	
	import mx.controls.ComboBox;
	import mx.events.ListEvent;
	
	public class OperatorFilterBase extends FilterBase
	{
		protected static const OPERATORS : Array = [new Operator("<", -1), new Operator("=", 0), new Operator(">", 1)];
		
		public var operatorComboBox : ComboBox;
		
		public function OperatorFilterBase()
		{
			super();
		}
		
		protected function onOperatorChange(event : ListEvent) : void
		{
			filterData.operator = Operator(operatorComboBox.selectedItem).value;
			sendChange();
		}
		
		protected function getOperatorIndex(value : Number) : Number
		{
			return value + 1;
		}
		
	}
}