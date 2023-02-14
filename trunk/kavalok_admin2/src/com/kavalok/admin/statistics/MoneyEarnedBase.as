package com.kavalok.admin.statistics
{
	import com.kavalok.admin.statistics.data.MoneyEarnedData;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.VBox;

	public class MoneyEarnedBase extends VBox
	{
		[Bindable]
		public var minDate : Date;
		[Bindable]
		public var maxDate : Date;
		
		[Bindable]
		public var dataProvider : MoneyEarnedData = new MoneyEarnedData();
		
		public function MoneyEarnedBase()
		{
			super();
			BindingUtils.bindProperty(dataProvider, "minDate", this, "minDate");
			BindingUtils.bindProperty(dataProvider, "maxDate", this, "maxDate");
		}
		
		
		public function refresh() : void
		{
			dataProvider.reload();
		}
	}
}