package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	public class EnablePictureChatCommand extends ServerCommandBase
	{
		override public function execute():void
		{
			var enabled:Boolean = (parameter == "true");
			if(!enabled){
				Dialogs.showOkDialog("Your picture chat has been disabled by a Chobots moderator. Please, contact support for more info.", true);
			}
			Global.charManager.pictureChat = enabled;
		}
	}
}