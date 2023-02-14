package com.kavalok.location.commands
{
	import com.kavalok.Global;
	
	public class MoveToLocCommand extends RemoteLocationCommand
	{
		public var locId:String;
		
		override public function execute():void
		{
			//Global.moduleManager.loadModule(locId);
		}
	}
}