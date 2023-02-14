package com.kavalok.admin.servers
{
	import com.kavalok.services.AdminService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;

	public class MailServersBase extends VBox
	{
		private static const LABEL_FORMAT : String = "{0}:{1} {2}";
		[Bindable]
		protected var servers : Array;
		
		public function MailServersBase()
		{
			super();
		}
		
		
		protected function getLabel(server : Object) : String
		{
			return StringUtil.substitute(LABEL_FORMAT, server.url, server.port, server.login);
		}
		protected function onInitialize(event : FlexEvent) : void
		{
			refresh();
		}
		
		protected function onAvailableClick(event : MouseEvent) : void
		{
			var button : Button = Button(event.target);
			new AdminService().setMailServerAvailable(button.data.id, button.selected);
		}
		
		protected function onRefreshClick(event : MouseEvent) : void
		{
			refresh();
		}
		
		private function refresh() : void
		{
			new AdminService(onGetServers).getMailServers();
		}
		
		private function onGetServers(result : Array) : void
		{
			servers = result;
		}
		
	}
}