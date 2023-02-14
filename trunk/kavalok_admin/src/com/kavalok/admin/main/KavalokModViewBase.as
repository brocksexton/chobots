package com.kavalok.admin.main
{
	import com.kavalok.admin.users.Users;
	import com.kavalok.admin.users.events.ShowFamilyEvent;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LoginService;
	
	import mx.containers.TabNavigator;
	import mx.core.Container;
	
	public class KavalokModViewBase extends MainViewBase
	{
		
		[Bindable]
		public var users : Users;
		[Bindable]
		public var tabNavigator : TabNavigator;

		[Bindable]
		protected var permissionLevel : uint = 0;


		[Bindable]
		protected var selectedPage : Container;
		
		public function KavalokModViewBase()
		{
			super();
		}
		
		override public function tryLogin(login : String, pass : String) : void
		{
			new LoginService(onLoginResult, onLoginFault).adminLogin2(login, pass);
			new AdminService(onGetPermissions).getPermissionLevel(login);
		}
		
		protected function onGetPermissions(level : uint) : void
		{
			permissionLevel = level;
		}
		protected function onShowFamily(event : ShowFamilyEvent) : void
		{
			tabNavigator.selectedChild = users;
			users.showFamily(event.email);
		}
	}
}