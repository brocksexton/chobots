package com.kavalok.dto
{
	[RemoteClass(alias="com.kavalok.dto.CompetitionTO")]
	public class CompetitionTO
	{
		[Bindable]
		public var name : String;
		[Bindable]
		public var start : Date;
		[Bindable]
		public var finish : Date;
		[Bindable]
		public var open : Boolean;
		public function CompetitionTO()
		{
		}

	}
}