package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.ThrowStarsAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	public class StarsAction extends ThrowAction
	{
		public static const ID:String = 'weaponStars';
		
		
		public function StarsAction():void
		{
			super(ThrowStarsAction)
//			_countTotal = 3;
			fightModel = WStarsFight;
			
			_showModel = WStarsShow;
			_shellModels = [WStarsShell1, WStarsShell2, WStarsShell3];
		}
		

		override public function get id():String
		{
			return ID;
		}
		
	}
}