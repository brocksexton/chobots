package com.kavalok.games
{
	public class TeamReadyClient extends ReadyClient
	{
		public function TeamReadyClient(remoteId:String)
		{
			super(remoteId);
		}
		
		override protected function sendReadyEvent() : void
		{
			ready.sendEvent(userState.team);
		}
	}
}