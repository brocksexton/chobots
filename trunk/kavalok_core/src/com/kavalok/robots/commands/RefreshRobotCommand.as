package com.kavalok.robots.commands
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.robots.Robot;
	import com.kavalok.services.RobotServiceNT;
	
	public class RefreshRobotCommand
	{
		private var _completeEvent:EventSender = new EventSender();
		
		public function RefreshRobotCommand()
		{
		}
		
		public function execute():void
		{
			new RobotServiceNT(onResult).getCharRobot(Global.charManager.userId);
		}
		
		private function onResult(result:RobotTO):void
		{
			Global.charManager.robot = new Robot(result);
			_completeEvent.sendEvent();
		}

		public function get completeEvent():EventSender { return _completeEvent; }
	}
}