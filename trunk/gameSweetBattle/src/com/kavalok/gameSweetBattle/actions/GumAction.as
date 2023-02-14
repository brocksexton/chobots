package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	import com.kavalok.gameSweetBattle.fightAction.ThrowGumAction;
	
	import com.kavalok.utils.Timers;
	
	public class GumAction extends StaticActionBase
	{
		public function GumAction()
		{
			super(ThrowGumAction);
			_countTotal = 5;
		}
		
		override public function get id():String
		{
			return "weaponGum";
		}
		
		override public function activate():void
		{
			stage.user.stopMove();
			Timers.callAfter(sendFightEvent, 1, this, [{}]);
		}
		
		override public function createAction(player:Player, params:Object):IFightAction
		{
			var action : ThrowGumAction = new ThrowGumAction(stage, player, params);
			action.throwConfig = new ThrowConfig(WGumFight, PlayerModelStay, [WGum]);
			return action;
		}
		
		
	}
}