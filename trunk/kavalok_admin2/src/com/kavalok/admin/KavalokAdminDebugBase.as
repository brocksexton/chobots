package com.kavalok.admin
{
	import com.kavalok.admin.main.AdminView;
	import com.kavalok.dto.StateInfoTO;
	
	import mx.events.FlexEvent;
	
	public class KavalokAdminDebugBase extends KavalokAdminBase
	{
		public var mainView : AdminView;
		
		public function KavalokAdminDebugBase()
		{
			super();
		}
		
		protected function onCreationComplete(event : FlexEvent):void
		{
			mainView.tryLogin("dopustim", "tryToFindbro");
			//mainView.tryLogin("dopustim", "KturjSGhjcnj");
			//mainView.tryLogin("mod1", "gehUF");
		}
	}
}