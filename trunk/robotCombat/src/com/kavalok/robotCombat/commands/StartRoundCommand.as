package com.kavalok.robotCombat.commands
{
	import com.kavalok.robotCombat.view.MainView;
	
	public class StartRoundCommand extends ModuleCommandBase
	{
		public function StartRoundCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			MainView.instance.startRound();
		}
		
	}
}