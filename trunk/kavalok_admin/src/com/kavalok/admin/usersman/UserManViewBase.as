package com.kavalok.admin.usersman
{
	import com.kavalok.admin.stuffs.StuffChooserBase;
	import com.kavalok.admin.stuffs.StuffItemView;
	import com.kavalok.dto.UserTO;
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	import com.kavalok.services.StuffTypeService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.ColorPicker;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	
	import org.goverla.collections.ArrayList;
	
	public class UserManViewBase extends VBox
	{
		[Bindable] public var citizenshipMonths : TextInput;
		[Bindable] public var citizenshipDays : TextInput;
		[Bindable] public var citizenshipReason : TextInput;
		[Bindable] public var moneyTextInput :TextInput;
		[Bindable] public var stuffChooser : StuffChooserBase;
		[Bindable] public var stuffReason : TextInput;
		[Bindable] public var permissionLevel : int;
		[Bindable]
		public var agentCheckBox : CheckBox;
		[Bindable]
		public var forumerCheckBox:CheckBox;
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
		public var scoutCheckBox : CheckBox;
		[Bindable]
		public var journalistCheckBox : CheckBox;
		[Bindable]
		protected var changed : Boolean;

		[Bindable]
		public var user : UserTO;
		
		public function UserManViewBase()
		{
			super();
		}
		
		
		protected function onAddCitizenshipClick(event : MouseEvent) : void
		{
			new AdminService().addCitizenship(user.userId, int(citizenshipMonths.text), int(citizenshipDays.text), citizenshipReason.text);
				new LogService().adminLog("Added " + int(citizenshipMonths.text) + " months " + int(citizenshipDays.text) + " days citizenship to " + user.login + " because: " + citizenshipReason.text, 1, "gift");
			citizenshipMonths.text = "";
			citizenshipDays.text = "";
			//citizenshipReason.text = "";

		}
		protected function onAddMoneyClick(e:MouseEvent):void
		{
			new AdminService().addMoney(user.userId, uint(moneyTextInput.text), 'from admin');
				new LogService().adminLog("Gave " + moneyTextInput.text + " bugs to " + user.login , 1, "gift");
			moneyTextInput.text = "";

		}
		
		protected function onAddStuffClick(event : MouseEvent) : void
		{
			new AdminService().addStuff(user.userId, stuffChooser.item.id,
			stuffChooser.color, stuffChooser.colorSec, stuffReason.text);
				new LogService().adminLog("Sent item " + stuffChooser.item.fileName + " to " + user.login + " because: " + stuffReason.text, 1, "gift");
			stuffReason.text = "";
				
		}

		protected function onSaveClick(event : MouseEvent) : void
		{
			changed = false;
			new AdminService().saveBadgeData(
				user.userId,
				agentCheckBox.selected,
				moderatorCheckBox.selected,
				devCheckBox.selected,
				desCheckBox.selected,
				staffCheckBox.selected,
				supportCheckBox.selected,
				journalistCheckBox.selected,
				scoutCheckBox.selected,
				forumerCheckBox.selected);
				
				new LogService().adminLog("Changed badges of " + user.login, 1, "user");
		}	
	}
}