package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.ReviewWordsData;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.LogService;
	
	public class ReviewWordsList extends KnownWordsList
	{
		public function ReviewWordsList()
		{
			super();
			dataProvider = new ReviewWordsData();
		}
		
		override protected function addWord(word : String):void
		{
			new MessageService(onAddWord).addReviewWord(word);
			new LogService().adminLog("Added review word: " + word, 1, "chat");
		}
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeReviewWord(id);
			new LogService().adminLog("Removed review word: " + id, 1, "chat");
		}

		
	}
}