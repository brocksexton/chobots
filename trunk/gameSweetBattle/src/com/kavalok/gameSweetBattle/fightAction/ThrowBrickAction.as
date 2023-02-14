package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_1_shuger_down;
	import com.kavalok.gameSweetBattle.SB_1_shuger_drop;
	import com.kavalok.Global;
	
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowBrickAction extends ThrowFightAction
	{
		private static const GRAVITY_MULT:Number = 1;
		private static const START_SPEED:Number = 500;
		private static const DAMAGE:int = 10;

		public function ThrowBrickAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			Global.playSound(SB_1_shuger_drop);
			
			var shell:WBrickShell = new WBrickShell();
			shell.mcRect.visible = false;
			var rect : Polygon = PhysicsEngine.createRectangle(shell.mcRect.width, shell.mcRect.height, new Vector2D(), 0.9);
			var object:PhysicsObject = createPhysicsObject(shell, coords, rect, DAMAGE, START_SPEED, GRAVITY_MULT);
		}

		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			if (source.sprite.alpha > 0.9)
				playSoundSafe(SB_1_shuger_down, 200);
			
			super.onCollide(source, target);
			processCollision(source);
		}
	}
}