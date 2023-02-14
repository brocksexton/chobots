package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.SkipWordsData;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.LogService;
	
	public class SkipWordsList extends KnownWordsList
	{
		public function SkipWordsList()
		{
			super();
			dataProvider = new SkipWordsData();
		}
		
		override protected function addWord(word : String):void
		{
			new MessageService(onAddWord).addSkipWord(word);
		new LogService().adminLog("Added skipped word: " + word, 1, "chat");
		}
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeSkipWord(id);
			new LogService().adminLog("Removed skipped word: " + id, 1, "chat");
		}
	
		
	}
}