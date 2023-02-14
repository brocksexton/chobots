package com.kavalok.robotCombat.commands
{
	import com.kavalok.commands.IAsincCommand;
	import com.kavalok.Global;
	import com.kavalok.robotCombat.CombatClient;
	import com.kavalok.robotCombat.view.MainView;
	import com.kavalok.utils.Strings;
	
	import flash.display.Sprite;
	
	public class StartupCommand extends ModuleCommandBase
	{
		private var _root:Sprite;
		
		public function StartupCommand(root:Sprite)
		{
			_root = root;
			super();
		}
		
		override public function execute():void
		{
			createClient();
			createView();
		}
		
		private function createClient():void
		{
			var remoteId:String = CombatClient.getRemoteId(
				Global.charManager.userId, RobotCombat.instance.opponentId);
			
			combat.client = new CombatClient();
			combat.client.connect(remoteId);
		}
		
		private function createView():void
		{
			var view:MainView = new MainView();
			combat.root = _root;
			combat.root.addChild(view.content);
		}
		
	}
}