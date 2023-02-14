package com.kavalok.admin.log.data
{
	import com.kavalok.services.MessageService;
	
	public class BadMessage extends UserMessage
	{
		public function BadMessage(login:String, userId : int, message:String, word : String, type : String)
		{
			this.info = word;
			super(login, userId, message, "allow", type);
		}
		
		override public function process():void
		{
			super.process();
			new MessageService().addAllowedWord(info, true);
			
		}
		
	}
}