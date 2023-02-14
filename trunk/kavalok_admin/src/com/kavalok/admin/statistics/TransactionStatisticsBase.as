package com.kavalok.admin.statistics
{
	import com.kavalok.services.StatisticsService;
	
	import mx.containers.VBox;
	
	import org.goverla.collections.ArrayList;

	public class TransactionStatisticsBase extends VBox
	{
		public var minDate : Date;
		public var maxDate : Date;
		
		[Bindable]
		protected var citizenDataProvider : ArrayList;

		[Bindable]
		protected var robotDataProvider : ArrayList;

		[Bindable]
		protected var citizenTotalCount : Number;

		[Bindable]
		protected var robotTotalCount : Number;
		
		[Bindable]
		protected var citizenTotalSum : Number;

		[Bindable]
		protected var robotTotalSum : Number;

		[Bindable]
		protected var totalSum : Number;
		
		
		public function TransactionStatisticsBase()
		{
			super();
		}
		
		protected function refresh() : void
		{
			new StatisticsService(onGetData).getTransactionStatistics(minDate, maxDate);
		}
		
		private function onGetData(result : Array) : void
		{
			citizenDataProvider = new ArrayList(result);
			citizenTotalCount = 0;
			citizenTotalSum = 0;
			for each(var item : Object in result)
			{
				citizenTotalCount+=item.count;
				citizenTotalSum+=item.sum;
			}
			new StatisticsService(onGetRobotData).getRobotTransactionStatistics(minDate, maxDate);
		}
		
		private function onGetRobotData(result : Array) : void
		{
			robotDataProvider = new ArrayList(result);
			robotTotalCount = 0;
			robotTotalSum = 0;
			for each(var item : Object in result)
			{
				robotTotalCount+=item.count;
				robotTotalSum+=item.sum;
			}
			totalSum = citizenTotalSum + robotTotalSum;
		}
	}
}