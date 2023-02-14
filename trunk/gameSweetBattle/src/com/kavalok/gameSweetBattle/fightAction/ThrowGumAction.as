package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_7_hirnja_drop;
	import com.kavalok.Global;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.Timers;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowGumAction extends ThrowFightAction
	{
		public static const DAMAGE : Number = 10;
		public static const PAUSE : Number = 3000;
		
		public function ThrowGumAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override public function execute():void
		{
			var direction : int = player.direction;
			super.execute();
			player.direction = direction;
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			Global.playSound(SB_7_hirnja_drop);
			
			var shell : MovieClip = new WGum();
			var rect : Polygon = PhysicsEngine.createRectangle(shell.width, 1, new Vector2D(), 0, 1000);
			var object : PhysicsObject = createPhysicsObject(shell, coords, rect, DAMAGE, 500, 5);
			object.angularVelocity = 0;
			object.rotation = Maths.degreesToRadians(player.rotation);
			object.collideHandler = null;
			object.velocity.x = object.velocity.y = 0;
			Timers.callAfter(activateGum, PAUSE, this, [object]);
		}
		
		private function activateGum(gum : PhysicsObject) : void
		{
			gum.angularVelocity = 0;
			gum.rotationLocked = true;
			gum.collideHandler = onCollide;
		}
		
		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			super.onCollide(source, target);
			if(target is Player)
			{
				playSoundSafe(SB_7_hirnja_drop);
				source.deleted = true;
			}
			
		}
		
		
	}
}