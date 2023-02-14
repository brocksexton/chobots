package com.kavalok.robotTeam
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.BuyConfirmCommand;
	import com.kavalok.gameplay.commands.MoneyAnimCommand;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.robots.RobotConstants;
	import com.kavalok.services.RobotService;
	
	public class CreateTeamCommand
	{
		private var _color:int;
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		
		public function CreateTeamCommand(color:int)
		{
			_color = color;
		}
		
		public function execute():void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated){
				module.closeModule();
				new RegisterGuestCommand().execute();
			}
			else if (Global.charManager.money < RobotConstants.TEAM_PRICE)
			{
				Dialogs.showOkDialog(Global.messages.noMoney);
			}
			else if (Global.charManager.robotTeam.isMine)
			{
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(
					_bundle.messages.teamExistsWarning);
				dialog.yes.addListener(createTeam);
			}
			else
			{
				createTeam();
			}
		}
		
		private function createTeam():void
		{
			new BuyConfirmCommand(RobotConstants.TEAM_PRICE, onBuyAccept).execute();
		}
		
		private function onBuyAccept():void
		{
			Global.isLocked = true;
			new RobotService(onCreationComplete).createTeam(_color);
		}
		
		private function onCreationComplete(result:Object):void
		{
			Global.isLocked = false;
			module.closeModule();
			Dialogs.showOkDialog(_bundle.messages.teamCreated);
			new MoneyAnimCommand(-RobotConstants.TEAM_PRICE).execute();
			Global.charManager.robotTeam.color = _color;
			Global.charManager.robotTeam.refresh();
			Global.sendAchievement("ac11;","Robot Team");
		}
		
		protected function get module():RobotTeam
		{
			return RobotTeam.instance;
		}
	}
}