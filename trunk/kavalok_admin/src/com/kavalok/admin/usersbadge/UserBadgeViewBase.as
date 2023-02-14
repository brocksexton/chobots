package com.kavalok.admin.usersbadge
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
	public class UserBadgeViewBase extends VBox
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
		public var agentCheckBox : CheckBox;
		[Bindable]
		public var ninjaCheckBox : CheckBox;
		[Bindable]
		public var staffCheckBox : CheckBox;
		[Bindable]
		public var devCheckBox : CheckBox;
		[Bindable]
		public var desCheckBox : CheckBox;
		[Bindable]
		public var moderatorCheckBox : CheckBox;
		[Bindable]
		public var supportCheckBox : CheckBox;
		[Bindable]
		public var journalistCheckBox : CheckBox;
		
		[Bindable]
		public var permissionLevel : int;

		[Bindable]
		protected var changed : Boolean;

		public function UserBadgeViewBase()
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
			new AdminService().saveBadgeData(
				user.userId,
				agentCheckBox.selected,
				moderatorCheckBox.selected,
				ninjaCheckBox.selected,
				devCheckBox.selected,
				desCheckBox.selected,
				staffCheckBox.selected,
				supportCheckBox.selected,
				journalistCheckBox.selected);
		}	
			
	}
}