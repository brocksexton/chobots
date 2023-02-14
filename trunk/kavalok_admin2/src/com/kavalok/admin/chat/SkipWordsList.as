package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.SkipWordsData;
	import com.kavalok.services.MessageService;
	
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
		}
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeSkipWord(id);
		}
	
		
	}
}