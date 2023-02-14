package com.kavalok.services
{
	import com.kavalok.dto.pet.PetTO;
	
	public class RobotService extends Red5ServiceBase
	{
		public function RobotService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function repairRobot(robotId:int):void
		{
			doCall('repairRobot', arguments);
		}
		
		public function buyItem(typeId:int, color:int):void
		{
			doCall('buyItem', arguments);
		}
		
		public function saveRobots(robots:Array, items:Array):void
		{
			doCall('saveRobots', arguments);
		}
		
		public function createTeam(color:int):void
		{
			doCall('createTeam', arguments);
		}
		
		public function addToTeam(ownerId:int):void
		{
			doCall('addToTeam', arguments);
		}
		
		public function removeFromTeam(userId:int):void
		{
			doCall('removeFromTeam', arguments);
		}
	}
}