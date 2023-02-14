package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.ThrowBrickAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	public class BrickAction extends ThrowAction
	{
		public static const ID:String = 'weaponBrick';
		
		
		
		public function BrickAction()
		{
			super(ThrowBrickAction)
			_countTotal = 5;
			
			_showModel = WBrickShow;
			fightModel = WBrickFight;
			_shellModels = [WBrickShell];
		}

		override public function get id():String
		{
			return ID;
		}
		
		
	}
	
}