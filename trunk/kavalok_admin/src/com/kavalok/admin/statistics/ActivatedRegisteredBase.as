package com.kavalok.admin.statistics
{
	import com.kavalok.services.StatisticsService;
	
	import mx.containers.VBox;

	public class ActivatedRegisteredBase extends VBox
	{
		[Bindable]
		public var minDate : Date;
		[Bindable]
		public var maxDate : Date;

		[Bindable]
		protected var dataProvider : Array;

		public function ActivatedRegisteredBase()
		{
			super();
		}
		
		protected function refresh() : void
		{
			new StatisticsService(onGetData).getActivationChart(minDate, maxDate, 10);
		}
		
		private function onGetData(result : Array) : void
		{
			dataProvider = result;
		}
	}
}