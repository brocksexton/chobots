package com.kavalok.admin.errors.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.services.ErrorService;

	public class ErrorsDataProvider extends PagedDataProvider
	{
		public function ErrorsDataProvider(itemsPerPage:uint=12)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			new ErrorService(onGetData).getErrors(currentPage * itemsPerPage, itemsPerPage);
		}
	}
}