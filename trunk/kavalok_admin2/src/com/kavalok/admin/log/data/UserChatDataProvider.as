package com.kavalok.admin.log.data
{
	import com.kavalok.services.AdminService;
	
	import mx.controls.Text;
	
	public class UserChatDataProvider
	{
		[Bindable]
		public var text : String;
		
		
		public function UserChatDataProvider()
		{
		}
		
		public function reload(userId : int) : void
		{
			new AdminService(onGetMessages).getLastChatMessages(userId);
		}
		
		private function onGetMessages(result : String) : void
		{
			text = result;
		}

	}
}