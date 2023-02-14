package com.kavalok.services
{
	public class MissionService extends Red5ServiceBase
	{
		public function MissionService(resultHandler:Function, faultHandler:Function = null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function completeMission(missionName : String) : void
		{
			doCall("completeMission", arguments);
		}
		
		public function getCompletedMissions(charName : String) : void
		{
			doCall("getCompletedMissions", arguments);
		}
	}
}