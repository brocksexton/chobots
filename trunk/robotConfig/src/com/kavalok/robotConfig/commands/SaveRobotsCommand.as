package com.kavalok.robotConfig.commands
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotItemSaveTO;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.dto.robot.RobotSaveTO;
	import com.kavalok.dto.robot.RobotTO;
	import com.kavalok.robots.Robot;
	import com.kavalok.services.RobotService;
	
	public class SaveRobotsCommand extends ModuleCommandBase
	{
		public function SaveRobotsCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			Global.isLocked = true;
			
			var robots:Array = [];
			for each (var robot:Robot in configData.robots)
			{
				var saveRobotTO:RobotSaveTO = new RobotSaveTO();
				saveRobotTO.id = robot.id;
				saveRobotTO.active = robot.active;
				robots.push(saveRobotTO);	
			}
			
			var items:Array = [];
			for each (var item:RobotItemTO in configData.items)
			{
				var saveItemTO:RobotItemSaveTO = new RobotItemSaveTO();
				saveItemTO.id = item.id;
				saveItemTO.robotId = item.robotId;
				saveItemTO.position = item.position;
				items.push(saveItemTO);	
			}
			
			new RobotService(onSaveComplete).saveRobots(robots, items);
		}
		
		private function onSaveComplete(result:RobotTO):void
		{
			Global.charManager.robot = new Robot(result);
			Global.isLocked = false;
			dispathComplete();
		}
		
	}
}