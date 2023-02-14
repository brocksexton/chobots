package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.PowerSight;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	import com.kavalok.gameSweetBattle.fightAction.ThrowFightAction;
	
	import flash.geom.Point;
	
	public class ThrowAction extends StaticActionBase
	{
		protected var fightModel : Class;
		
		protected var _sight:PowerSight;
		
		protected var _shellModels:Array;
		
		protected var _countPerAction:int = 1;
		protected var _countUsed:int;
		
		public function ThrowAction(type : Class) 
		{
			super(type);
		}
		
		public override function activate():void
		{

			stage.sendStopUser();
			_sight = new PowerSight(stage.user);
			stage.content.addChild(_sight.content);
				
			_sight.fightEvent.setListener(onFight);
			_sight.powerEvent.setListener(onPower);
			_sight.show();
		}
		
		override public function createAction(player:Player, params:Object):IFightAction
		{
			var action : ThrowFightAction = ThrowFightAction(super.createAction(player, params));
			action.throwConfig = new ThrowConfig(fightModel, showModel, _shellModels);
			return action;
		}
		
		private function onPower():void
		{
//			stage.lockActions();
		}
		
		private function onFight():void
		{
			if(_sight != null && stage != null && stage.user != null)
			{
				var data:Object = { };
				data.playerDirection = stage.user.direction;
				data.sightDirection = _sight.direction;
				data.power = _sight.power;
				
				removeSight();
				sendFightEvent(data);
				stage.lockActions();
			}
			else
			{
				stage.selectDefaultAction();
			}
		}
		

		protected function createShell(shellClass:Class, coords:Point):void {}
		
		public override function terminate():void
		{
			if (_sight)
				removeSight();
		}
		
		private function removeSight():void
		{
			stage.content.removeChild(_sight.content)
			_sight = null;
		}
		
	}
	
}