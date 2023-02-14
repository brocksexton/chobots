package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_6_bable_down;
	import com.kavalok.gameSweetBattle.SB_6_bable_drop;
	import com.kavalok.Global;
	
	import flash.geom.Point;
	
	import com.kavalok.utils.Timers;
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowBubbleAction extends ThrowFightAction
	{
		private static const LIFE_TIME:Number = 10000;
		private static const IDLE_TIME:Number = 12000;
		private static const GRAVITY_MULT:Number = 0.05;
		private static const START_SPEED:Number = 100;
		private static const DAMAGE:int = 0;

		public function ThrowBubbleAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			Global.playSound(SB_6_bable_drop);
			
			var shell:WBubble = new WBubble();
			shell.cacheAsBitmap = true;
			shell.scaleX = shell.scaleY = Config.PLAYER_SCALE;
			var shape:Circle = new Circle(shell.width /2 , new Vector2D(0, 0), new Material(2, Config.DEF_FRICTION, Config.DEF_DENSITY));
			shape.data = this;
			
			var object : PhysicsObject = createPhysicsObject(shell, coords, shape, DAMAGE, START_SPEED, GRAVITY_MULT);
			object.mass = 1000;
			object.angularVelocity = 0;
			object.rotationLocked = true;
			Timers.callAfter(deleteObject, LIFE_TIME, this, [object]);
		}
		
		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			if (source.sprite.alpha > 0.9)
				playSoundSafe(SB_6_bable_down, 100);
			
			super.onCollide(source, target);
			processCollision(source, 0.4);
			if(target is Player)
			{
				source.deleted = true;
				catchPlayer(Player(target), source.position.clone());
			}
		}
		
		private function deleteObject(object : PhysicsObject) : void
		{
			object.deleted = true;
		}
		
		private function catchPlayer(player : Player, bubbleCoords : Point) : void
		{
			if(player.isUser)
			{
				Timers.callAfter(player.sendRemoveBubble, IDLE_TIME);
				player.stopMove();
				player.sendAddBubble(bubbleCoords);
			}
		}
	}
}