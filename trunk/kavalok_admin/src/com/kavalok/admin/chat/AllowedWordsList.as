package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.AllowedWordsData;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.LogService;
	public class AllowedWordsList extends KnownWordsList
	{
		public function AllowedWordsList()
		{
			super();
			dataProvider = new AllowedWordsData();
		}
		
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeAllowedWord(id);
			new LogService().adminLog("Removed allowed word: " + id, 1, "chat");
		}
		override protected function addWord(word : String):void
		{
			new MessageService(onAddWord).addAllowedWord(word, false);
			new LogService().adminLog("Added allowed word: " + word, 1, "chat");
		}
		
	}
}