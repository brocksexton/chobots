package com.kavalok.dto
{
	import flash.net.registerClassAlias;
	
	[RemoteClass(alias="com.kavalok.dto.CompetitionResultTO")]
	public class CompetitionResultTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.CompetitionResultTO", CompetitionResultTO);
		}

		public var competitionName : String; 
		public var login : String;
		public var score : Number;
		public var finish : Date;
		
  		public function CompetitionResultTO()
		{
		}

	}
}