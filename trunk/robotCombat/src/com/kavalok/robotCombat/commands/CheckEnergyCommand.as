package com.kavalok.robotCombat.commands
{
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	
	public class CheckEnergyCommand extends ModuleCommandBase
	{
		public function CheckEnergyCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if (combat.myPlayer.robot.energy == 0
				|| combat.opponentPlayer.robot.energy == 0)
			{
				combat.finished = true;
				var message:String = bundle.messages.noEnergy;
				var dialog:DialogOkView = Dialogs.showOkDialog(message);
				dialog.ok.addListener(onOk);
			}
		}
		
		private function onOk():void
		{
			new QuitCommand().execute();
		}
		
	}
}