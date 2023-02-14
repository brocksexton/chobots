package com.kavalok.admin.main
{
	import com.kavalok.admin.users.Users;
	import com.kavalok.admin.users.events.ShowFamilyEvent;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LoginService;
	import com.kavalok.Global;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.LogService;
	
	import mx.containers.TabNavigator;
	import mx.core.Container;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class AdminViewBase extends MainViewBase
	{
		
		[Bindable]
		public var users : Users;
		[Bindable]
		public var tabNavigator : TabNavigator;
		[Bindable]
		public var bbd : Boolean = false;

		[Bindable]
		protected var permissionLevel : uint = 0;
		
		[Bindable]
		protected var magic : Boolean = false;


		[Bindable]
		protected var selectedPage : Container;
		
		public function AdminViewBase()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		override public function tryLogin(login : String, pass : String) : void
		{
			new LoginService(onLoginResult, onLoginFault).tretreAdminlol(login, pass);
			new AdminService(onGetPermissions).getPermissionLevel(login);
			new AdminService(onGetPanelName).getPanelName(login);
			new AdminService(onGetMagicLevel).getMagic(login);
		}
		private function onMouseDown(e:MouseEvent):void
		{
				/*if (e.ctrlKey && e.altKey && e.shiftKey)
				{
					//permissionLevel = 100;
					bbd = true;
				}*/
		}
		protected function onGetPanelName(name:String):void
		{
			Global.panelName = name;
			new MessageService().modAction(name, "Logged in", Global.getPanelDate());
			new LogService().adminLog("Logged in successfully", 1, "login");
		}
		protected function onGetPermissions(level : uint) : void
		{
			permissionLevel = level;
			
		}
		protected function onGetMagicLevel(magicLevel : Boolean) : void
		{
			magic = magicLevel;
		}
		protected function onShowFamily(event : ShowFamilyEvent) : void
		{
			tabNavigator.selectedChild = users;
			users.showFamily(event.email);
		}
	}
}