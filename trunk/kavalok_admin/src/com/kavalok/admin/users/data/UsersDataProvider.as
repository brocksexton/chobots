package com.kavalok.admin.users.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.services.AdminService;
	
	import org.goverla.collections.ArrayList;

	public class UsersDataProvider extends PagedDataProvider
	{
		private var _server : int = -2;
		private var _filters : ArrayList = new ArrayList();

		public function UsersDataProvider()
		{
			super();
		}
		
		public function set server(value : int) : void
		{
			_server = value;
		}
		
		public function set filters(value : ArrayList) : void
		{
			_filters = value;
		}
		
		override public function reload():void
		{
			new AdminService(onGetData).getUsers(_server, _filters.toArray(), currentPage * itemsPerPage, itemsPerPage);
		}
		
	}
}