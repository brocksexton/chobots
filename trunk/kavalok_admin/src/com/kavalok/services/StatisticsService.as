package com.kavalok.services
{
	import mx.controls.Alert;
	
	public class StatisticsService extends Red5ServiceBase
	{
		public function StatisticsService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getMoneyEarned(minDate : Date, maxDate : Date, firstResult : int, maxResults : int) : void
		{
			doCall("getMoneyEarned", arguments);
		}
		
		public function getMembersAge(minDate : Date, maxDate : Date, period : int) : void
		{
			doCall("getMembersAge", arguments);
		} 
		public function getPurchaseStatistics(minDate : Date, maxDate : Date) : void 
		{
			doCall("getPurchaseStatistics", arguments);
		}
	
  		public function getActivationChart(minDate : Date, maxDate : Date, count : int) : void
  		{
			doCall("getActivationChart", arguments);
  		}
  		public function getLoadChart(minDate : Date, maxDate : Date, count : int) : void
		{
			doCall("getLoadChart", arguments);
		}
		public function getTotalLogins(minDate : Date, maxDate : Date) : void
		{
			doCall("getTotalLogins", arguments);
		}
		public function getUserLogins(minDate : Date, maxDate : Date, startFrom : int, count : uint) : void
		{
			doCall("getUserLogins", arguments);
		}
		
		public function getUsersChart(minDate : Date, maxDate : Date, count : int) : void
		{
			doCall("getUsersChart", arguments);
		}

		public function getTransactionStatistics(minDate : Date, maxDate : Date) : void
		{
			var minD : String = minDate.getFullYear()+"-"+(minDate.getMonth()+1)+"-"+minDate.getDate();
			var maxD : String = maxDate.getFullYear()+"-"+(maxDate.getMonth()+1)+"-"+maxDate.getDate();
			doCall("getTransactionStatistics", [minD, maxD]);
		} 

		public function getRobotTransactionStatistics(minDate : Date, maxDate : Date) : void
		{
			var minD : String = minDate.getFullYear()+"-"+(minDate.getMonth()+1)+"-"+minDate.getDate();
			var maxD : String = maxDate.getFullYear()+"-"+(maxDate.getMonth()+1)+"-"+maxDate.getDate();
			doCall("getRobotTransactionStatistics", [minD, maxD]);
		} 

	}
}