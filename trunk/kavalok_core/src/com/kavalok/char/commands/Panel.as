package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	//import com.kavalok.dialogs.DialogSheenieView;
	import com.kavalok.commands.location.GotoLocationCommand;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	//import common.utils.StringUtil;

	public class Panel extends CharCommandBase
	{

		override public function execute():void
		{
			if(Global.charManager.isModerator)
			initializePanel(true);
			trace("Done");
		}
		
		private function initializePanel(result:Boolean):void
		{	
			//var dialog:DialogSheenieView = Dialogs.showSheenieDialog();
		}
	}

}