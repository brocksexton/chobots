package com.kavalok.admin.statistics
{
	import com.kavalok.services.StatisticsService;
	
	import mx.containers.VBox;
	
	import org.goverla.collections.ArrayList;

	public class PurchaseStatisticsBase extends VBox
	{
		public var minDate : Date;
		public var maxDate : Date;
		
		[Bindable]
		protected var dataProvider : ArrayList;
		
		public function PurchaseStatisticsBase()
		{
			super();
		}
		
		protected function refresh() : void
		{
			new StatisticsService(onGetData).getPurchaseStatistics(minDate, maxDate);
		}
		
		private function onGetData(result : Array) : void
		{
			dataProvider = new ArrayList(result);
		}
		
	}
}