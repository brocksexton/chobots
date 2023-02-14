package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	import com.kavalok.gameSweetBattle.fightAction.WalkFightAction;
	import com.kavalok.gameplay.MousePointer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PlayerRunAction extends PlayerWalkAction
	{
		public static const SPEED:int = 4;
		public static const ID:String = 'playerRun';
		
		public function PlayerRunAction(stage : GameStage)
		{
			super(stage);
		}
		
		override public function createAction(player:Player, params:Object):IFightAction
		{
			var result : WalkFightAction = WalkFightAction(super.createAction(player, params));
			result.playerSpeed = SPEED;
			return result;
		}

		override public function get id():String
		{
			return ID;
		}
		
		override protected function onWalkAreaPress(e:MouseEvent):void 
		{
			_walkArea.visible = false;
			super.onWalkAreaPress(e);
		}
		
	}
}