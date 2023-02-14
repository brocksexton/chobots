package com.kavalok.admin.chat.data
{
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;

	public class SkipWordsData extends WordsDataProvider
	{
		public function SkipWordsData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			if(!Strings.isBlank(part))
				new MessageService(onGetData).findSkipWord("%" + part + "%", currentIndex, itemsPerPage);
			else
				new MessageService(onGetData).getSkipWords(currentIndex, itemsPerPage);
		}
		
	}
}