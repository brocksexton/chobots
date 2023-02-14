package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.ThrowRoAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	public class RoAction extends ThrowAction
	{
		public static const ID:String = 'weaponRo';
		
		public function RoAction():void
		{
			super(ThrowRoAction)
//			_countTotal = -1;
			_countPerAction = 3;
			fightModel = WRoFight;
			
			_showModel = WRoShow;
			_shellModels = [WRoShell];
		}
		
		
		override public function get id():String
		{
			return ID;
		}
		
	}
	
}