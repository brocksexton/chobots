package com.kavalok.dto
{
	[RemoteClass(alias="com.kavalok.dto.LoginStatisticsTO")]
	public class LoginStatisticsTO
	{
		[Bindable]
		public var secondsInGame : Number;
		[Bindable]
		public var averageTime : Number;
		[Bindable]
		public var loginCount : int;

		public function LoginStatisticsTO()
		{
		}

	}
}