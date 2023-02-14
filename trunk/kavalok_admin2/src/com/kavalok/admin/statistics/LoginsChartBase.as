package com.kavalok.admin.statistics
{
	import com.kavalok.services.StatisticsService;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.utils.TimeUtils;

	public class LoginsChartBase extends VBox
	{
		private static const COUNT : uint = 10;
		
		public var minDate : Date;
		public var maxDate : Date;
		
		[Bindable]
		protected var dataProvider : ArrayCollection;
		
		public function LoginsChartBase()
		{
			super();
		}
		
		protected function refresh() : void
		{
			new StatisticsService(onGetData).getUsersChart(minDate, maxDate, COUNT);
		}
		
		private function onGetData(result : Array) : void
		{
			for each(var item : Object in result)
			{
				if(item.secondsInGame == null)
					item.secondsInGame = 0;
			}
			dataProvider = new ArrayList(result);
			
		}
		
	}
}