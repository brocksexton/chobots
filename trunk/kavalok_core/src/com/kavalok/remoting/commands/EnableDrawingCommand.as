package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	public class EnableDrawingCommand extends ServerCommandBase
	{
		override public function execute():void
		{
			var enabled:Boolean = (parameter == "true");
			if(!enabled){
				Dialogs.showOkDialog(Global.resourceBundles.kavalok.messages.drawingDisabledByMod, true);
			}
			Global.charManager.drawEnabled = enabled;
		}
	}
}