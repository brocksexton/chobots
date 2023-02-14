package com.kavalok.robotConfig.commands
{
	public class CloseCommand extends ModuleCommandBase
	{
		public function CloseCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if (configData.changed)
			{
				var command:SaveRobotsCommand = new SaveRobotsCommand();
				command.completeEvent.addListener(onSaveComplete);
				command.execute();
			}
			else
			{
				RobotConfig.instance.closeModule();
			}
		}
		
		private function onSaveComplete(sender:SaveRobotsCommand):void
		{
			RobotConfig.instance.closeModule();
		}
		
	}
}