package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.security.Base64;
	
	public class llalalalalalal8912381232 extends ServerCommandBase
	{
		public function llalalalalalal8912381232()
		{
			super();
		}
		
		override public function execute():void
		{
			var key:String = String(parameter);
	
			Global.charManager.privKey = key;//Base64.decode(rlKey);
			trace("New key received");
	
		}
	}
}