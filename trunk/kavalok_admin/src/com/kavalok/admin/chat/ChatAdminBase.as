package com.kavalok.admin.chat
{
	import com.kavalok.services.AdminService;
	import com.kavalok.services.MessageService;
	
	import mx.containers.VBox;
	import mx.events.FlexEvent;
	
	public class ChatAdminBase extends VBox
	{
		
		public function ChatAdminBase()
		{
		}
		
		public function onPurgeCache():void
		{
			trace("ima reset chat cache, mkkkk??");
			
			new AdminService().flushChatWordCaches();
			
		}
		
	}
}