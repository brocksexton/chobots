package com.kavalok.admin.statistics.data
{
	import com.kavalok.services.StatisticsService;
	
	public class MoneyEarnedData extends PagedDataProvider
	{
		public var minDate : Date;
		public var maxDate : Date;

		public function MoneyEarnedData()
		{
			super();
		}
		
		override public function reload() : void
		{
			new StatisticsService(onGetData).getMoneyEarned(minDate, maxDate, currentPage * itemsPerPage, itemsPerPage);
		}

	}
}