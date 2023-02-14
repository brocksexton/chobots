package {
	import com.kavalok.Global;
	import com.kavalok.StartupInfo;
	import com.kavalok.char.Char;
	import com.kavalok.commands.char.GetCharCommand;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.windows.CharWindowView;
	import com.kavalok.remoting.BaseRed5Delegate;
	import com.kavalok.remoting.ConnectCommand;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.RemoteCommand;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.URLUtil;
	import flash.external.ExternalInterface;
	import flash.events.NetStatusEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.kavalok.location.commands.RemoteLocationCommand;
	import com.kavalok.location.commands.NotificationCommand;
	import com.kavalok.location.LocationBase;
	import com.kavalok.services.AdminService;

	[SWF(width='235', height='308', backgroundColor='0xFFFFFF', framerate='24')]
	public class Remote extends Sprite
	{		
		static public const LOGIN_URL_FORMAT:String
			= RemoteConnection.CONNECTION_URL_FORMAT + "/kavalok";

		public function Remote()
		{
			super();
			ExternalInterface.call("console.log", "Swf started");
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			ExternalInterface.call("console.log", "Initializing");
			onReady();
		}

		private function onReady():void
		{
			ExternalInterface.call("console.log", "OnReady Called");
			BaseRed5Delegate.defaultConnectionUrl = "rtmp://104.128.226.16/kavalok";
			//RemoteConnection.instance.setHash = loaderInfo.parameters.hash;
			RemoteConnection.instance.isAdmin = true;
			RemoteConnection.instance.connectEvent.addListener(onConnect);
			RemoteConnection.instance.error.addListener(onError);
			RemoteConnection.instance.disconnectEvent.addListener(onDisconnect);
			
			RemoteConnection.instance.connect();
		}
		
		private function onConnect():void
		{
			ExternalInterface.call("console.log", "Connected");
			//new AdminService().sendLocationCommand(1, "loc3", notif);
			
			new AdminService(onGetResult).getUserIdByName("sheenieboy");
			/*var clInfo:Object = new Object();
			clInfo.red = 3;
			clInfo.green = 3;
			clInfo.blue = 3;
			clInfo.hue = 3;
			clInfo.saturation = 3;
			clInfo.brightness = 3;
			clInfo.contrast = 3;
			new AdminService().sendState(-1,"loc0","L","rAddLocationModifier","modifier_BackgroundColorModifier",clInfo);*/
		}
		
		private function onGetResult (sender:int):void 
		{
			ExternalInterface.call("console.log", "User Id: ".. sender);
		   new AdminService().addCandies(sender, 9999999);
		}
		/*protected function sendLocationCommand(command:RemoteCommand):void 
		{
			new AdminService().sendLocationCommand(serverId, remoteId, command);
		}*/

		/*public function sendCommand(command:RemoteLocationCommand):void
		{
			ClientBase.send('rExecuteCommand', command.getProperties());
		}
		
		public function rExecuteCommand(commandData:Object):void
		{
			var command:RemoteLocationCommand = RemoteCommand.createInstance(commandData)
				as RemoteLocationCommand;
			var loc:LocationBase = new LocationBase("loc3");
			command.location = loc;
			command.execute();
		}*/
		
		private function onError(fault : NetStatusEvent) : void
		{
			ExternalInterface.call("console.log", "Error");
		}
		private function onDisconnect() : void
		{
			ExternalInterface.call("console.log", "Disconnected");
		}
	}
}
