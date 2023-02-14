package com.kavalok.admin.messages.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.services.AdminService;

	public class AdminMessagesData extends PagedDataProvider
	{
		public function AdminMessagesData()
		{
			super(20);
		}
		
		override public function reload():void
		{
			super.reload();
			new AdminService(onGetData).getAdminMessages(currentPage * itemsPerPage, itemsPerPage);
		}
		
	}
}