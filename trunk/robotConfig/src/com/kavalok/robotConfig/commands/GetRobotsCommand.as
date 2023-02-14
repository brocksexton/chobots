package com.kavalok.robotConfig.commands
{
	import com.kavalok.services.RobotServiceNT;
	
	public class GetRobotsCommand extends ModuleCommandBase
	{
		private var _result:Array;
		
		public function GetRobotsCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			new RobotServiceNT(onComplete).getRobotsLite();
		}
		
		private function onComplete(result:Array):void
		{
			_result = result;
			dispathComplete();
		}
		
		public function get result():Array
		{
			 return _result;
		}
		
	}
}