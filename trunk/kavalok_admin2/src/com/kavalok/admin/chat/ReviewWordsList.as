package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.ReviewWordsData;
	import com.kavalok.services.MessageService;
	
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
		}
		override internal function removeWord(id : int) : void 
		{
			new MessageService(onRemoveWord).removeReviewWord(id);
		}
		
	}
}