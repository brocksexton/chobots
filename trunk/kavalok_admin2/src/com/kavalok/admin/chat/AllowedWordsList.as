package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.AllowedWordsData;
	import com.kavalok.services.MessageService;
	
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
		}
		override protected function addWord(word : String):void
		{
			new MessageService(onAddWord).addAllowedWord(word, false);
		}
		
	}
}