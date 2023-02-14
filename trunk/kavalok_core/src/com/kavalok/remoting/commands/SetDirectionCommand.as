package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;

	public class SetDirectionCommand extends ServerCommandBase
	{
		
		public function SetDirectionCommand()
		{
		}

		override public function execute():void
		{
			   var text:String = String(parameter);
			   var modelName:String = text.split("#")[0];
			   var direction:int = parseInt(text.split("#")[1]);
			   trace("direction: " + direction);
			   trace("modelName: " + modelName);
			   trace("text: " + text);
				Global.charManager.setModel(modelName, direction);

			
		}
		
	}
}