package com.kavalok.admin.chat.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;

	public class WordsDataProvider extends PagedDataProvider
	{
		private var _part : String;
		
		public function WordsDataProvider(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		public function get part() : String
		{
			return _part;
		}
		
		public function set part(value : String) : void
		{
			_part = value;
			reload();
		}
		
	}
}