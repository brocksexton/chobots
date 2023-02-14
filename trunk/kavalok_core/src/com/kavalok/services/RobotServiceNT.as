package com.kavalok.services
{
	import com.kavalok.dto.pet.PetTO;
	
	public class RobotServiceNT extends Red5ServiceBase
	{
		public function RobotServiceNT(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getItem(itemId:int):void
		{
			doCall('getItem', arguments);
		}
		
		public function getTopScores():void
		{
			doCall('getTopScores', arguments);
		}
		
		public function getTeamTopScores():void
		{
			doCall('getTeamTopScores', arguments);
		}
		
		public function getCharRobot(userId:int):void
		{
			doCall('getCharRobot', arguments);
		}
		
		public function getRobotsLite():void
		{
			doCall('getRobotsLite', arguments);
		}
		
		public function getAllItems():void
		{
			doCall('getAllItems', arguments);
		}
		
		public function getCombatData(soId:String):void
		{
			doCall('getCombatData', arguments);
		}
	}
}