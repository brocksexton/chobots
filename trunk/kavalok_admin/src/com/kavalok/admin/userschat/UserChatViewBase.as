package com.kavalok.admin.userschat
{
	import com.kavalok.Global;
	import com.kavalok.admin.users.events.ShowFamilyEvent;
	import com.kavalok.dto.UserTO;
	import com.kavalok.gameplay.LocalSettings;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LoginService;
	import com.kavalok.char.CharModels;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.DateField;
	import mx.controls.TextInput;
		import mx.controls.ComboBox;
			import org.goverla.collections.ArrayList;
	
	[Event(name="showFamily", type="com.kavalok.admin.users.events.ShowFamilyEvent")]
	public class UserChatViewBase extends VBox
	{
		private var _user:UserTO;
		[Bindable]
		public function get user():UserTO
		{
			return _user;
		}
		public function set user(value:UserTO):void
		{
			_user = value;
			refresh();
		}
		

		
		[Bindable]
		public var permissionLevel : int;

		[Bindable]
		protected var changed : Boolean;
		
		[Bindable] public var chatComboBox:ComboBox;
		[Bindable] public var chat:ArrayList = new ArrayList(CharModels.COLORS);

		public function UserChatViewBase()
		{
			super();
			refresh();
		}
		
		private function refresh():void
		{
			enabled = Boolean(user);
		}

	
		protected function onSaveClick(event : MouseEvent) : void
		{
			changed = false;
			new AdminService().saveChatData(
				user.userId,
				selectedChat);
		}	
			
		public function get selectedChat():String
		{
			return String(chatComboBox.selectedItem);
		}	
	}
}