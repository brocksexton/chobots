package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.char.CharModels;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.location.commands.PlaySwfCommand;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.utils.AdminConsole;
	
	public class MagicAction extends CharActionBase
	{
		
		override public function execute():void
		{
			_char.stopMoving();
			_char.setModel(CharModels.MAGIC);
			
			trace(Global.charManager.magicItem);
			if (_parameters && _parameters.name && _char.isUser && Global.charManager.magicItem != null)
			{
				var command:PlaySwfCommand = new PlaySwfCommand();
				command.url = animationURL;
				command.hash = Global.locationManager.location.locHash;
			
				_location.sendCommand(command);
				Global.addCheck(1,"magic");
			}
		
		}
		
		public function get animationURL():String
		{
			return URLHelper.resourceURL(_parameters.name, 'magic');
		}
	
	}
}