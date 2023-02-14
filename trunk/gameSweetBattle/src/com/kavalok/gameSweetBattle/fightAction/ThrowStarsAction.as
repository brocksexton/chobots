package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_2_star_down;
	import com.kavalok.gameSweetBattle.SB_2_star_drop;
	import com.kavalok.Global;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowStarsAction extends ThrowFightAction
	{
		private static const GRAVITY_MULT:Number = 1;
		private static const START_SPEED:Number = 500;
		private static const DAMAGE:int = 4;

		public function ThrowStarsAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			playSoundSafe(SB_2_star_drop);
			
			var shell:MovieClip = new shellClass();
			var shape : Circle = new Circle(0.5 * shell.width, new Vector2D(0,0));
			
			var fo:PhysicsObject = createPhysicsObject(shell, coords, shape, DAMAGE, START_SPEED, GRAVITY_MULT);
			fo.elast = 0.8;
			fo.body.setMoment(Config.DEF_INERT * 0.1);
			fo.angularVelocity = 5;
		}
		
		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			if (source.sprite.alpha > 0.9)
				playSoundSafe(SB_2_star_down, 500);
			
			super.onCollide(source, target);

			source.sprite.alpha -= 0.03;
			if (source.sprite.alpha <= 0)
				source.deleted = true;
			
		}
	}
}