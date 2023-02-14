package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.services.ServerService;
	import com.kavalok.gameplay.commands.CacheWarningCommand;
	
	public class RefreshBuildCommand extends ServerCommandBase
	{
		private var _servers : Array;
		private var _disableChat:Boolean;

		public function RefreshBuildCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var disableChat:Boolean = "true" == String(parameter);
			_disableChat = disableChat;
			Global.isLocked = true;
			new ServerService(onGetServers).getServers();
		}
	
		private function onGetServers(result:Array):void
		{
			_servers = result;
			var server : Object = Arrays.firstByRequirement(_servers, new PropertyCompareRequirement("name", Global.loginManager.server));
			if (Global.buildNum != server.build){

				if (_disableChat){
				//Dialogs.showOkDialog("Chobots has been updated! Please refresh and clear your cache for build " + server.build, false);
				new CacheWarningCommand("ingame").execute();
				} else {
					RemoteConnection.instance.disconnect();
				Dialogs.showOkDialog("Chobots has been updated! You should refresh and clear your cache for build " + server.build, true);
		    	}

			//	Global.localSettings.newBuild = true;
			}
			Global.isLocked = false;
		}
		

		}
	}


