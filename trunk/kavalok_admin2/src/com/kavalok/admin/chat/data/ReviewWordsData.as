package com.kavalok.admin.chat.data
{
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;

	public class ReviewWordsData extends WordsDataProvider
	{
		public function ReviewWordsData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			if(!Strings.isBlank(part))
				new MessageService(onGetData).findReviewWord("%" + part + "%", currentIndex, itemsPerPage);
			else
				new MessageService(onGetData).getReviewWords(currentIndex, itemsPerPage);
		}
		
	}
}