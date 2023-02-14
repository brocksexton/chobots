package com.kavalok.admin.worldconfig.data
{
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	
	public class WorldConfigData
	{
		[Bindable]
		public var safeModeEnabled : Boolean;
		[Bindable]
		public var drawingWallDisabled:Boolean;
		
		public function WorldConfigData()
		{
			new AdminService(onResult).getWorldConfig();
		}
		
		public function update() : void
		{
			new AdminService().saveWorldConfig(safeModeEnabled, drawingWallDisabled);
			
			new LogService().adminLog("Set safe mode " + safeModeEnabled, 1, "world config"); 
				
			new LogService().adminLog("Set drawingWallDisabled : " + drawingWallDisabled, 1, "world config");

		}
		
		private function onResult(result:Object) : void
		{
			safeModeEnabled = result.safeModeEnabled;
			drawingWallDisabled = result.drawingEnabled;
		}

	}
}