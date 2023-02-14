package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_5_tarilka_down;
	
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowPlateAction extends ThrowFightAction
	{
		private static const GRAVITY_MULT:Number = 0;
		private static const START_SPEED:Number = 500;
		private static const DAMAGE:int = 10;
		private static const ELAST:Number = 2;

		public function ThrowPlateAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			var shell:WPlateShell = new WPlateShell();
			var rect : Polygon = PhysicsEngine.createRectangle(shell.width, shell.height, new Vector2D(), ELAST);
			var object:PhysicsObject = createPhysicsObject(shell, coords, rect, DAMAGE, START_SPEED, GRAVITY_MULT);
			object.angularVelocity = 0;
			object.rotation = Math.atan2(object.velocity.y, object.velocity.x);
			object.rotationLocked = true;
			
		}

		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			playSoundSafe(SB_5_tarilka_down, 200);
			
			super.onCollide(source, target);
			processCollision(source);
//			source.angularVelocity = 0;
			source.rotation = Math.atan2(source.velocity.y, source.velocity.x);
		}
	}
}