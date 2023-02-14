package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.actions.PlayerWalkAction;
	
	import flash.geom.Point;

	public class WalkFightAction extends FightActionBase
	{
		protected var _playerSpeed:int = 2;

		public function WalkFightAction(stage : GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		public function set playerSpeed(value : int) : void
		{
			_playerSpeed = value;
		}
		
		override public function execute():void
		{
			if(player == null)
				return;
			if(player.isUser)
			{
				stage.selectUserAction(PlayerWalkAction.ID);
			}
			player.speed = _playerSpeed;
			player.setModelClass(PlayerModelWalk);
			player.moveOnSurface(stage.surface, new Point(data.x, data.y));
		}
		
	}
}