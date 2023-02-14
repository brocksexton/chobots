package com.kavalok.services
{
	public class CompetitionService extends SecuredRed5ServiceBase
	{
		public function CompetitionService(resultHandler:Function=null)
		{
			super(resultHandler);
		}
		
		public function addCompetitorResult(competitorLogin: String, competitionName : String, result : Number) : void
		{
			doCall("addCompetitorResult", arguments);
		}

		public function addResult(competitionName : String, result : Number) : void
		{
			doCall("addResult", arguments);
		}
		
	}
}