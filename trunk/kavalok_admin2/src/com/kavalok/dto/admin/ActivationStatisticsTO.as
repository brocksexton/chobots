package com.kavalok.dto.admin
{
	[RemoteClass(alias="com.kavalok.dto.admin.ActivationStatisticsTO")]
	public class ActivationStatisticsTO
	{
		[Bindable]
		public var registered : int;
		[Bindable]
		public var activated : int;
		[Bindable]
		public var date : Date;

		public function ActivationStatisticsTO()
		{
		}

	}
}