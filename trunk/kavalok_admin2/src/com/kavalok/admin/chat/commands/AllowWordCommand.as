package com.kavalok.admin.chat.commands
{
	import com.kavalok.admin.chat.data.WordData;
	import com.kavalok.services.MessageService;

	public class AllowWordCommand extends WordCommandBase
	{
		public function AllowWordCommand(data:WordData)
		{
			super(data);
		}
		
		override public function execute():void
		{
			new MessageService(onResult,onFault).addAllowedWord(wordData.item.word, true);
		}
		
	}
}