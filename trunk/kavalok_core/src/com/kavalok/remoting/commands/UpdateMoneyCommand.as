package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	
	public class UpdateMoneyCommand extends ServerCommandBase
	{
		public function UpdateMoneyCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			Global.charManager.money = Number(parameter);
		}
	}
}