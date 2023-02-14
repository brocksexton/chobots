package com.kavalok.admin.chat.commands
{
	import com.kavalok.admin.chat.data.WordData;
	import com.kavalok.services.MessageService;

	public class BlockWordCommand extends WordCommandBase
	{
		public function BlockWordCommand(data:WordData)
		{
			super(data);
		}
		
		override public function execute():void
		{
			new MessageService(onResult,onFault).addBlockWord(wordData.item.word);
		}
	}
}