package com.kavalok.admin.magic
{
	import com.kavalok.admin.locations.LocationsData;
	import com.kavalok.admin.servers.ServersData;
	import com.kavalok.location.commands.MoveToLocationCommand;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.Strings;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import com.kavalok.Global;
	import com.kavalok.services.MessageService;
	import mx.controls.Alert;
	import org.goverla.collections.ArrayList;
	import com.kavalok.services.LogService;
	import flash.events.Event;

	public class MagicBase extends MagicViewBase
	{
		[Bindable] public var serversComboBox:ComboBox;
		[Bindable] public var serversData:ServersData;

		[Bindable] public var locationsComboBox:ComboBox;
		[Bindable] public var remoteIdField:TextInput;
		[Bindable] public var locationsData:LocationsData = new LocationsData();
		[Bindable] public var moveInput:TextInput;

		public function MagicBase()
		{
			serversData = new ServersData();
			serversData.servers.addItem( { label: "All servers\n\n\n", id: -1 } );
			super();
		}

		public function clearRemoteObject():void
		{
			if (serverId == -1)
			Alert.show('This command could not be executed on all servers.');
			else
			new AdminService().clearSharedObject(serverId, remoteId);

			new MessageService().modAction(Global.panelName, "Cleared location " + remoteId, Global.getPanelDate());
			new LogService().adminLog("Cleared location " + remoteId, 1, "magic");
		}

		public function setPreferredRemoteId():void 
		{
			locationsComboBox.selectedItem = null;
			remoteId = Strings.trim(remoteIdField.text);
		}

		public function set locationId(value:String):void 
		{
			remoteIdField.text = value;
			remoteId = value;
		}
		public function moveCharsCommand():void
		{
			var locId:String = Strings.trim(moveInput.text);

			if (!Strings.isBlank(locId) && serverId != -1)	
			{
				var command:MoveToLocationCommand = new MoveToLocationCommand();
				command.locId = locId;
				sendLocationCommand(command);
			}
			new MessageService().modAction(Global.panelName, "Moved users to " + locId, Global.getPanelDate());
			new LogService().adminLog("Moved users from " + remoteId + " to " + locId, 1, "magic");

		}

	}

}