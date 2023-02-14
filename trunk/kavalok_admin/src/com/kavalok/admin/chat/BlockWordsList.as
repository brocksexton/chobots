package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.BlockWordsData;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.LogService;
	
	public class BlockWordsList extends KnownWordsList
	{
		public function BlockWordsList()
		{
			super();
			dataProvider = new BlockWordsData();
		}
		
		override protected function addWord(word : String):void
		{
			new MessageService(onAddWord).addBlockWord(word);
			new LogService().adminLog("Added blocked word: " + word, 1, "chat");
		}
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeBlockWord(id);
			new LogService().adminLog("Removed blocked word: " + id, 1, "chat");
		}
		
	}
}