package com.kavalok.services
{
	public class GameService extends Red5ServiceBase
	{
		public function GameService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getScore(scoreId:String, topCount:int):void
		{
			doCall("getScore", arguments);
		}
	}
}