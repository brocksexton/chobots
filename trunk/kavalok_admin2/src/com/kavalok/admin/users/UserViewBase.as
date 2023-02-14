package com.kavalok.admin.users
{
	import com.kavalok.Global;
	import com.kavalok.admin.users.events.ShowFamilyEvent;
	import com.kavalok.dto.UserTO;
	import com.kavalok.gameplay.LocalSettings;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LoginService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	
	[Event(name="showFamily", type="com.kavalok.admin.users.events.ShowFamilyEvent")]
	public class UserViewBase extends VBox
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
		public var chatEnabledCheckBox : CheckBox;
		[Bindable]
		public var chatEnabledByParentCheckBox : CheckBox;
		[Bindable]
		public var activatedCheckBox : CheckBox;
		[Bindable]
		public var agentCheckBox : CheckBox;
		[Bindable]
		public var moderatorCheckBox : CheckBox;
		[Bindable]
		public var banedCheckBox : CheckBox;
		[Bindable]
		public var drawEnabledCheckBox : CheckBox;
		[Bindable]
		public var banReasonTextInput : TextInput;
		[Bindable]
		public var banDateField : DateField;
		[Bindable]
		public var banDateButton : Button;
		
		[Bindable]
		public var permissionLevel : int;

		[Bindable]
		protected var changed : Boolean;

		public function UserViewBase()
		{
			super();
			refresh();
		}
		
		private function refresh():void
		{
			enabled = Boolean(user);
		}
		
		protected function onShowFamilyClick(event : MouseEvent):void
		{
			dispatchEvent(new ShowFamilyEvent(user.email));
		}
		
		protected function onDisableChat(periodNumber:int):void
		{
			user.banCount = periodNumber;
			new AdminService().setDisableChatPeriod(user.userId, periodNumber);
		}
		
		private function onBanDateResult(result:Object):void
		{
			banDateButton.enabled = true;
		}
		
		protected function onSendRulesClick(event : MouseEvent) : void
		{
			new AdminService().sendRules(user.userId);
		}
		protected function onKickOutClick(event : MouseEvent) : void
		{
			new AdminService().kickOut(user.userId, false);
		}
		
		protected function onSendMailClick(event : MouseEvent) : void
		{
			new LoginService().sendActivationMail(Global.startupInfo.redirectURL || "", user.login, user.locale || LocalSettings.DEFAULT_LOCALE);
		}
		
		protected function onSaveClick(event : MouseEvent) : void
		{
			changed = false;
			new AdminService().saveUserData(
				user.userId,
				activatedCheckBox.selected,
				chatEnabledCheckBox.selected,
				chatEnabledByParentCheckBox.selected,
				agentCheckBox.selected,
				user.baned,
				moderatorCheckBox.selected,
				drawEnabledCheckBox.selected);
		}
		
		protected function onUnBanClick(event : MouseEvent) : void
		{
			user.baned = false;
			new AdminService().saveUserBan(user.userId, false, banReasonTextInput.text);
		}
		protected function onUnBanIPClick(event : MouseEvent) : void
		{
			user.ipBaned = false;
			new AdminService().saveIPBan(user.ip, false, banReasonTextInput.text);
		}
		protected function onBanClick(event : MouseEvent) : void
		{
			user.baned = true;
			new AdminService().saveUserBan(user.userId, true, banReasonTextInput.text);
			new AdminService(onSaveUserBan).getUser(user.userId);
			banReasonTextInput.text = "";
		}
		protected function onBanIPClick(event : MouseEvent) : void
		{
			user.ipBaned = true;
			new AdminService().saveIPBan(user.ip, true, banReasonTextInput.text);
			new AdminService(onSaveUserBan).getUser(user.userId);
			banReasonTextInput.text = "";
		}
		
		protected function onSaveUserBan(result : Object) : void
		{
			if(result!=null)
				user = UserTO(result);
		}
		
		
		
	}
}