package com.kavalok.admin.statistics
{
	import mx.containers.VBox;

	public class LoginStatisticsBase extends VBox
	{
		[Bindable]
		public var minDate : Date;
		[Bindable]
		public var maxDate : Date;

		public function LoginStatisticsBase()
		{
			super();
		}
		
		
	}
}