package com.kavalok.services
{
	public class CompetitionDataService extends Red5ServiceBase
	{
		public function CompetitionDataService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}

		public function getMyCompetitionResult(competitionName : String, firstResult : int, maxResults : int) : void
		{
			doCall("getMyCompetitionResult", arguments);
		}
		public function getCompetitionResults(competitionName : String, firstResult : int, maxResults : int)  : void
		{
			doCall("getCompetitionResults", arguments);
		}
		
		public function startCompetition(name:String, start:Date, finish:Date)  : void
		{
			doCall("startCompetition", arguments);
		}

  		public function clearCompetition(name : String) : void
  		{
  			doCall("clearCompetition", arguments);
  		}
  		public function getCompetitions() : void
  		{
  			doCall("getCompetitions", arguments);
  		}
		
	}
}