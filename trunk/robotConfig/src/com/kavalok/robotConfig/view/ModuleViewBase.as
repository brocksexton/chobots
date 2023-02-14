package com.kavalok.robotConfig.view
{
	import com.kavalok.robotConfig.RobotConfigData;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.Global;
	
	public class ModuleViewBase
	{
		public function ModuleViewBase()
		{
		}
		
		public function get configData():RobotConfigData
		{
			 return RobotConfigData.instance;
		}
		
		public function get bundle():ResourceBundle
		{
			 return Global.resourceBundles.robots;
		}

	}
}