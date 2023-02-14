package com.kavalok.admin.magic
{
	import com.kavalok.admin.locations.LocationsData;
	import com.kavalok.admin.servers.ServersData;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.Strings;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.controls.Alert;
	import org.goverla.collections.ArrayList;

	
	public class MagicBase extends MagicViewBase
	{
		[Bindable] public var serversComboBox:ComboBox;
		[Bindable] public var serversData:ServersData;
		
		[Bindable] public var locationsComboBox:ComboBox;
		[Bindable] public var remoteIdField:TextInput;
		[Bindable] public var locationsData:LocationsData = new LocationsData();
		
		public function MagicBase()
		{
			serversData = new ServersData();
			serversData.servers.addItem( { label: "All server\n\n\n", id: -1 } );
			super();
		}
		
		public function clearRemoteObject():void
		{
			if (serverId == -1)
				Alert.show('Choose server');
			else
				new AdminService().clearSharedObject(serverId, remoteId);
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
	}
	
}