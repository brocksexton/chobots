package com.kavalok.admin.statistics.data
{
	import com.kavalok.services.StatisticsService;

	public class LoginsByUserData extends PagedDataProvider
	{
		public var minDate : Date;
		public var maxDate : Date;
		
		
		public function LoginsByUserData()
		{
			super();
		}
		
		
		
		override public function reload() : void
		{
			new StatisticsService(onGetData).getUserLogins(minDate, maxDate, currentPage * itemsPerPage, itemsPerPage);
		}
		
	}
}