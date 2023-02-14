package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.BlockWordsData;
	import com.kavalok.services.MessageService;
	
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
		}
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeBlockWord(id);
		}
		
	}
}