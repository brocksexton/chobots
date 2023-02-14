package com.kavalok.admin.chat.commands
{
	import com.kavalok.admin.chat.data.WordData;
	import com.kavalok.services.MessageService;

	public class SkipWordCommand extends WordCommandBase
	{
		public function SkipWordCommand(data:WordData)
		{
			super(data);
		}
		
		override public function execute():void
		{
			new MessageService(onResult,onFault).addSkipWord(wordData.item.word);
		}
	}
}