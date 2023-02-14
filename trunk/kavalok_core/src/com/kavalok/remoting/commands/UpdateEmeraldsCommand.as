package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	
	public class UpdateEmeraldsCommand extends ServerCommandBase
	{
		public function UpdateEmeraldsCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			Global.charManager.emeralds = Number(parameter);
		}
	}
}