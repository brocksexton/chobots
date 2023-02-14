package com.kavalok.admin.log.data
{
	import com.kavalok.services.MessageService;
	import com.kavalok.Global;
	import com.kavalok.services.AdminService;
	
	public class BadMessage extends UserMessage
	{
		//var hhhLogin:String;
		//var hhhId:String;
		public function BadMessage(login:String, userId : int, message:String, word : String, type : String)
		{
			this.info = word;
			super(login, userId, message, "warn", type);
		}
		
		override public function process():void
		{
			super.process();
		//	new MessageService().addAllowedWord(info, true);
			new AdminService().sendRules(userId);
			new MessageService().modAction(Global.panelName, "Sent rules to " + login, Global.getPanelDate());
			
		}
		
	}
}