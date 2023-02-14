package com.kavalok.robotConfig.commands
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robots.Robots;
	
	public class UnUseItemCommand extends ModuleCommandBase
	{
		private var _item:RobotItemTO;
		
		public function UnUseItemCommand(item:RobotItemTO)
		{
			_item = item;
		}
		
		override public function execute():void
		{
			_item.unUse();
			configData.updateRobot();
		}
	}
}