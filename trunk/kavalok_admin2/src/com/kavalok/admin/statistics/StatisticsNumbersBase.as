package com.kavalok.admin.statistics
{
	import com.kavalok.dto.LoginStatisticsTO;
	import com.kavalok.dto.admin.ActivationStatisticsTO;
	import com.kavalok.services.StatisticsService;
	
	import mx.containers.VBox;

	public class StatisticsNumbersBase extends VBox
	{
		public var minDate : Date;
		public var maxDate : Date;
		
		[Bindable]
		protected var activations : ActivationStatisticsTO;
		[Bindable]
		protected var loginStatistics : LoginStatisticsTO;

		public function StatisticsNumbersBase()
		{
			super();
		}
		
		protected function refresh() : void
		{
			new StatisticsService(onGetTotalLogins).getTotalLogins(minDate, maxDate);
			new StatisticsService(onGetActivations).getActivationChart(minDate, maxDate, 1);
		}
		
		private function onGetTotalLogins(result : LoginStatisticsTO) : void
		{
			loginStatistics = result;
		}
		private function onGetActivations(result : Array) : void
		{
			activations = result.length > 0 ? result[0] : null;
				
		}
		
	}
}