package com.kavalok.services
{
	public class UpdateScoreService extends SecuredRed5ServiceBase
	{
		public function UpdateScoreService(resultHandler:Function=null)
		{
			super(resultHandler);
		}
		
		public function updateScore(scoreId : String, score : Number) : void
		{
			doCall("updateScore", arguments);
		}
	}
}