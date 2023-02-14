package com.kavalok.remoting.commands
{
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.commands.ServerCommandBase;

	public class AgentRulesCommand extends ServerCommandBase
	{
		
		public function AgentRulesCommand()
		{
		}

		override public function execute():void
		{
			var warnInfo:String = String(parameter);
			Dialogs.showAgentRulesDialog(warnInfo);
		}
		
	}
}