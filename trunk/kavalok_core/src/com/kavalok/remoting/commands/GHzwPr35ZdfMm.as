package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.security.Base64;
	
	public class GHzwPr35ZdfMm extends ServerCommandBase
	{
		public function GHzwPr35ZdfMm()
		{
			super();
		}
		
		override public function execute():void
		{
			var key:String = String(parameter);
	
			Global.charManager.privKey = Base64.decode(key);//key;//
			trace("New key received");
	
		}
	}
}