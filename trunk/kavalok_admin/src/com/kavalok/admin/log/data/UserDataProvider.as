package com.kavalok.admin.log.data
{
	import com.kavalok.dto.UserTO;
	import com.kavalok.services.AdminService;
	
	public class UserDataProvider
	{
		[Bindable]
		public var user : UserTO;
		
		public function UserDataProvider()
		{
		}
		
		public function load(userId : int) : void
		{
			new AdminService(onLoadUser).getUser(userId);
		}
		
		private function onLoadUser(result : UserTO) : void
		{
			user = result;
		}

	}
}