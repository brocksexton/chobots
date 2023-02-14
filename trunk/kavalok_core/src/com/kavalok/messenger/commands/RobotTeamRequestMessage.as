package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.RobotTeam;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.RobotService;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	
	public class RobotTeamRequestMessage extends MessageBase
	{
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		
		override public function execute():void
		{
			var team:RobotTeam = Global.charManager.robotTeam;
			if (team.isMine && !team.isFreeSpace)
			{
				new MessageService().sendCommand(senderUserId, new RobotTeamFullMessage());
			}
			else
			{
				if (!messageExists())
					super.execute();
			}
		}
		
		override public function getText():String
		{
			return Strings.substitute(_bundle.messages.teamRequest, sender);
		}
		
		override public function getIcon():Class
		{
			return McMsgCombatIcon;
		}
		
		override public function show():void
		{
			showConfirmation(_bundle.messages.teamMessageCaption, getText(), onAccept);
		}
		
		protected function onAccept(e:Event = null):void
		{
			closeDialog();
			if (Global.charManager.robotTeam.isMine)
			{
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(_bundle.messages.teamExistsWarning);
				dialog.yes.addListener(addToTeam);
			}
			else
			{
				addToTeam();
			}
		}
		
		private function addToTeam():void
		{
			Global.isLocked = true;
			new RobotService(onAdded).addToTeam(senderUserId);
		}
		
		private function onAdded(result:Object):void
		{
			Global.isLocked = false;
			var message:RobotTeamRespondMessage = new RobotTeamRespondMessage();
			new MessageService().sendCommand(senderUserId, message);
			Global.charManager.robotTeam.refresh();
		}
	}
}