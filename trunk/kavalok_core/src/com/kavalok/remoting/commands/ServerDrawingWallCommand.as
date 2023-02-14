package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	public class ServerDrawingWallCommand extends ServerCommandBase
	{
		
		public function ServerDrawingWallCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var disableWalls:Boolean = Boolean(parameter);
			
		//	Global.charManager.serverChatDisabled = disableWalls;
			Global.charManager.serverDrawDisabled = disableWalls;
			
			//Dialogs.showOkDialog(disableChat ? Global.resourceBundles.kavalok.messages.gameSafeModeOn : Global.resourceBundles.kavalok.messages.gameSafeModeOff);
		}
	
	}
}

