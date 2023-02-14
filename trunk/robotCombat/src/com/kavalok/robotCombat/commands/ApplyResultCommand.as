package com.kavalok.robotCombat.commands
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.robotCombat.CombatPlayer;
	import com.kavalok.robotCombat.CombatSounds;
	import com.kavalok.robotCombat.actions.CombatAction;
	import com.kavalok.robotCombat.view.LostView;
	import com.kavalok.robotCombat.view.WinView;
	import com.kavalok.robots.RobotModel;
	import com.kavalok.robots.RobotModels;
	import com.kavalok.robots.RobotUtil;
	import com.kavalok.robots.commands.RefreshRobotCommand;
	import com.kavalok.utils.MoviePlayer;
	
	public class ApplyResultCommand extends ModuleCommandBase
	{
		public function ApplyResultCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			combat.finished = combat.myPlayer.result.finished;
			
			mainView.waitingVisible = false;
			
			var command:CombatAction = new CombatAction(
				combat.myPlayer, combat.opponentPlayer);
			command.completeEvent.addListener(onMyComplete);
			command.execute();
		}
		
		private function onMyComplete(sender:Object):void
		{
			var command:CombatAction = new CombatAction(
				combat.opponentPlayer, combat.myPlayer);
			command.completeEvent.addListener(onOpponentComplete);
			command.execute();
		}
		
		private function onOpponentComplete(sender:Object):void
		{
			if (combat.myPlayer.result.finished)
			{
				new RefreshRobotCommand().execute();
				
				if (combat.myPlayer.robot.energy == 0)
					destroyModel(combat.myPlayer);
				
				if (combat.opponentPlayer.robot.energy == 0)
					destroyModel(combat.opponentPlayer);
				
				if (combat.myPlayer.robot.energy == 0)
					applyLost();
				else
					applyWin();
			}
			else
			{
				checkSpecialItem();
				combat.client.sendComplete();
			}
		}
		
		private function checkSpecialItem():void
		{
			var itemId:int = combat.myPlayer.result.specialItemId;
			if (itemId != -1)
			{
				var item:RobotItemTO = combat.myPlayer.robot.getItem(itemId);
				if (item.useCount > 0)
					item.remains--; 
			}
		}
		
		private function applyLost():void
		{
			Global.playSound(CombatSounds.LOSE);
			new LostView().show();
		}
		
		private function applyWin():void
		{
			Global.playSound(CombatSounds.WON);
			
			var money:int = RobotUtil.getEarnedMoney(combat.opponentPlayer.robot.level);
			new AddMoneyCommand(money, "combat").execute();
			
			combat.myPlayer.robot.energy = combat.myPlayer.result.energy;
			combat.dispatchChange();
			new WinView().show();
		}
		
		private function destroyModel(player:CombatPlayer):void
		{
			var model:RobotModel = mainView.getPlayerView(player.userId).robotView.model; 
			model.setModel(RobotModels.DESTROY);
			new MoviePlayer(model.content).play(); 
			
		}
		
	}
}