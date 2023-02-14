package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.ThrowCakeAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	public class CakeAction extends ThrowAction
	{
		public static const ID:String = 'weaponCake';
		
		
		public function CakeAction()
		{
			super(ThrowCakeAction)
			_countTotal = 3;
			fightModel = WCakeFight;
			
			_showModel = WCakeShow;
			_shellModels = [WCakeShell];
		}
		
		override public function get id():String
		{
			return ID;
		}
		
	}
	
}