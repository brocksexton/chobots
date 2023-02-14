package com.kavalok.dto
{
	import flash.net.registerClassAlias;
	
	public class MoneyReportTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.MoneyReportTO", MoneyReportTO);
		}

		public var earned : Number;
		public var inviteesEarned : Number;
		public var bonus : Number;
	}
}