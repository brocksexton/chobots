package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.ThrowCornAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	
	public class CornAction extends ThrowAction
	{
		public static const ID:String = 'weaponCorn';
		
		public function CornAction()
		{
			super(ThrowCornAction)
			_countTotal = 2;
			fightModel = WCornFight;
			
			_showModel = PlayerModelStay;
			_shellModels = [WCornShell];
		}

		override public function get id():String
		{
			return ID;
		}
		
	}
	
}