package com.kavalok.games
{
	public class TeamNotReadyClient extends NotReadyClient
	{
		private var _team : uint;
		
		public function TeamNotReadyClient(remoteId:String, team : uint)
		{
			_team = team;
			super(remoteId);
		}
		
		override protected function processState(state:Object):void
		{
			state.team = _team;
		}
		
	}
}