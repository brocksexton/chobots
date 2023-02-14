package com.kavalok.admin.statistics
{
	import com.kavalok.admin.statistics.data.LoginsByUserData;
	import com.kavalok.services.StatisticsService;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.VBox;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.StringUtil;
	
	import org.goverla.utils.TimeUtils;

	public class LoginsByUserBase extends VBox
	{
		private static const TOTAL_FORMAT : String = "total usage time: {0} total logins: {1} average time in system: {2}";
		
		[Bindable]
		public var minDate : Date;
		[Bindable]
		public var maxDate : Date;
		
		[Bindable]
		public var totalData : Object;

		[Bindable]
		protected var dataProvider : LoginsByUserData = new LoginsByUserData();


		public function LoginsByUserBase()
		{
			super();
			BindingUtils.bindProperty(dataProvider, "minDate", this, "minDate");
			BindingUtils.bindProperty(dataProvider, "maxDate", this, "maxDate");
		}
		
		protected function refresh() : void
		{
			dataProvider.reload();
			new StatisticsService(onGetTotal).getTotalLogins(minDate, maxDate);
		}
		
		protected function getTotalString(data : Object) : String
		{
			var time : String = TimeUtils.getTimeString(data.secondsInGame * 1000);
			var averageTime : String = TimeUtils.getTimeString(data.secondsInGame * 1000 / data.loginCount);
			return StringUtil.substitute(TOTAL_FORMAT, time, data.loginCount, averageTime);
		}
		private function onGetTotal(result : Object) : void
		{
			totalData = result;
		}
		
	}
}