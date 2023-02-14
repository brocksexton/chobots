package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.GraphityUtil;
	import com.kavalok.utils.Arrays;
	
	public class DrawingDisabledCommand extends ServerCommandBase
	{
		
		public function DrawingDisabledCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var disableDrawing:Boolean = "true" == String(parameter);
			
			Global.charManager.serverDrawDisabled = disableDrawing;
		
			Dialogs.showOkDialog(disableDrawing ? "Graffiti in the Underground is now Enabled." : "Graffiti in the Underground is now Disabled.");
			
			new GraphityUtil().loadGraphity();
			
			var locs : Array = new Array ("locGraphity", "locGraphityA", "locGraphityM");
			
			if(locs.indexOf(Global.locationManager.locationId) != -1){
			Global.moduleManager.loadModule(Global.locationManager.locationId);
			}
		}
	
	}
}

