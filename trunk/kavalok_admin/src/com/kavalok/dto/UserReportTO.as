package com.kavalok.dto
{
	[RemoteClass(alias="com.kavalok.dto.UserReportTO")]
	public class UserReportTO
	{
		public var userId : int;
		
		public var login : String;
		
		public var reportsCount : int;
		
		public var text : String;

		public var processed : Boolean;

		public function UserReportTO()
		{
		}

	}
}