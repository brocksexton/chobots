package com.kavalok.admin.chat.data
{
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;

	public class AllowedWordsData extends WordsDataProvider
	{
		public function AllowedWordsData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			if(!Strings.isBlank(part))
				new MessageService(onGetData).findAllowedWord("%" + part + "%", currentIndex, itemsPerPage);
			else
				new MessageService(onGetData).getAllowedWords(currentIndex, itemsPerPage);
		}
	}
}