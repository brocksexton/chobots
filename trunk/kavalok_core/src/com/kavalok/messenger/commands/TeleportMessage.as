package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.commands.location.GotoLocationCommand;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	
	public class TeleportMessage extends MessageBase
	{
		public var locId:String;
		public var server:String
		public var parameters : Object;
	//	public var text:String;
	//	
		public function TeleportMessage()
		{
			locId = Global.locationManager.locationId;
			server = Global.loginManager.server
			parameters = Global.locationManager.location.invitationParams;
		}
		
		override public function getIcon():Class
		{
			return McMsgInviteIcon;
		}
		
		override public function execute():void
		{
			if (!messageExists() && !atSameLocation)
				super.execute();
		}
		
		override public function show():void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(getText());
			dialog.yes.addListener(applyTransfer);
		}
		
		override public function getText():String
		{
			if(!text)
			return Strings.substitute(Global.messages.teleportReceive, sender, Global.messages[locId]) 
			else
			return Strings.substitute(Global.messages.teleportReceiveLong, sender, Global.messages[locId], text) 
			
		}
		
		protected function applyTransfer(e:Event = null):void
		{ 
			trace("initializing transfer to location id: " + locId + " and remoteId " + parameters.remoteId);
			if (!atSameLocation) 
			{
				if(Global.loginManager.server != server)
					new GotoLocationCommand(locId, parameters, server).execute();
				else
					new GotoLocationCommand(locId, parameters).execute();
			}
		}
		
		private function get atSameLocation():Boolean
		{
			return Global.locationManager.locationId == locId
				&& Global.locationManager.remoteId == parameters.remoteId
				&& Global.loginManager.server == server;
		}
	}
}