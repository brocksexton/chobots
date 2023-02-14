package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	import com.kavalok.gameSweetBattle.fightAction.LandFightAction;
	
	public class LandAction extends StaticActionBase
	{
		private var _id : String;
		private var _config : Object;
		
		public function LandAction(id : String, config : Object)
		{
			super(LandFightAction);
			_id = id;
			_config = config;
		}
		
		override public function set stage(value:GameStage):void
		{
			super.stage = value;
			stage.field[id].gotoAndStop(1);
		}
		
		override public function createAction(player : Player, params : Object) : IFightAction
		{
			var action : LandFightAction = LandFightAction(super.createAction(player, params));
			action.config = _config;
			return action;
		}
		override public function get id():String
		{
			return _id;
		}
		
		override public function activate():void
		{
			sendFightEvent({});
		}
		
	}
}