package com.kavalok.admin.chat.commands
{
	import com.kavalok.admin.chat.data.WordData;
	import com.kavalok.services.UserService;

	public class BlockChatCommand extends WordCommandBase
	{
		public function BlockChatCommand(wordData:WordData)
		{
			super(wordData);
		}
		
		override public function execute():void
		{
			new UserService(onResult, onFault).blockUserChat(wordData.item.userEmail);
		}
		
	}
}