package com.kavalok.admin.chat.data
{
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;

	public class BlockWordsData extends WordsDataProvider
	{
		public function BlockWordsData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			if(!Strings.isBlank(part))
				new MessageService(onGetData).findBlockWord("%" + part + "%", currentIndex, itemsPerPage);
			else
				new MessageService(onGetData).getBlockWords(currentIndex, itemsPerPage);
		}
		
	}
}