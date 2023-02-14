package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.utils.Maths;

	public class ReconnectCommand extends ServerCommandBase
	{

		public function ReconnectCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			Global.loginManager.changeServer(String(parameter), Locations.getRandomLocation());
		}
		
	}
}