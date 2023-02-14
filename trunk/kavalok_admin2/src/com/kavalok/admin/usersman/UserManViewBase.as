package com.kavalok.admin.usersman
{
	import com.kavalok.admin.stuffs.StuffChooserBase;
	import com.kavalok.admin.stuffs.StuffItemView;
	import com.kavalok.dto.UserTO;
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.StuffTypeService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.ColorPicker;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.TextInput;
	
	import org.goverla.collections.ArrayList;
	
	public class UserManViewBase extends VBox
	{
		[Bindable] public var citizenshipMonths : TextInput;
		[Bindable] public var citizenshipDays : TextInput;
		[Bindable] public var citizenshipReason : TextInput;
		[Bindable] public var stuffChooser : StuffChooserBase;
		[Bindable] public var stuffReason : TextInput;
		[Bindable] public var permissionLevel : int;

		[Bindable]
		public var user : UserTO;
		
		public function UserManViewBase()
		{
			super();
		}
		
		protected function onDeleteClick(event : MouseEvent) : void
		{
			new AdminService().deleteUser(user.userId);
		}
		
		protected function onAddCitizenshipClick(event : MouseEvent) : void
		{
			new AdminService().addCitizenship(user.userId, int(citizenshipMonths.text), int(citizenshipDays.text), citizenshipReason.text);
			citizenshipMonths.text = "";
			citizenshipDays.text = "";
			citizenshipReason.text = "";
		}
		
		protected function onAddStuffClick(event : MouseEvent) : void
		{
			new AdminService().addStuff(user.userId, stuffChooser.item.id,
				stuffChooser.color, stuffReason.text);
			stuffReason.text = "";
		}
	}
}