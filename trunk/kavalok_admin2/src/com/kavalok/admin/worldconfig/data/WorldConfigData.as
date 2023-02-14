package com.kavalok.admin.worldconfig.data
{
	import com.kavalok.services.AdminService;
	
	public class WorldConfigData
	{
		[Bindable]
		public var safeModeEnabled : Boolean;
		
		public function WorldConfigData()
		{
			new AdminService(onResult).getWorldConfig();
		}
		
		public function update() : void
		{
			new AdminService().saveWorldConfig(safeModeEnabled);
		}
		
		private function onResult(result:Object) : void
		{
			safeModeEnabled = result.safeModeEnabled;
		}

	}
}