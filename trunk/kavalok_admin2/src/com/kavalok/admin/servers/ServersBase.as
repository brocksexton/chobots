package com.kavalok.admin.servers
{
	import com.kavalok.dto.ServerTO;
	import com.kavalok.services.AdminService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;

	public class ServersBase extends VBox
	{
		public var moveToComboBox : ComboBox;
		
		[Bindable]
		protected var dataProvider : ServersData = new ServersData();
		
		public function ServersBase()
		{
			super();
		}
		
		protected function onAvailableClick(event : MouseEvent) : void
		{
			var button : Button = Button(event.target);
			new AdminService().setServerAvailable(button.data.id, button.selected);
			
		}
		protected function onMoveUsersClick(event : MouseEvent) : void
		{
			var from : ServerTO = event.target.data;
			var to : ServerTO = ServerTO(moveToComboBox.selectedItem);
			new AdminService().moveUsers(from.id, to.id);
		}
		protected function onRebootClick(event : MouseEvent) : void
		{
			var server : Object = event.currentTarget.data;
			new AdminService(onServerReboot).reboot(server.name);
		}
		
		
		protected function onServerReboot(result : Object) : void
		{
			dataProvider.refresh();
		}
		protected function onRefreshClick(event : MouseEvent) : void
		{
			dataProvider.refresh();
		}
		
		
		
		
	}
}