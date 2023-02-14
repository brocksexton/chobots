package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.services.CharService;
	import com.kavalok.char.CharManager;
	
	public class BodyChange extends StuffCommandBase
	{
		override public function apply():void
		{
			Global.charManager.body = parameters.body;
			new CharService().saveCharBodyNormal(parameters.body, Global.charManager.color);
		}
		
		override public function restore():void
		{
			Global.charManager.body = "default";
			new CharService().saveCharBodyNormal("default", Global.charManager.color);
		}
	}
}

