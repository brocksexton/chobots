package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_3_cake_down;
	import com.kavalok.gameSweetBattle.SB_3_cake_drop;
	import com.kavalok.gameSweetBattle.SB_z_anithing_down;
	import com.kavalok.Global;
	
	import flash.geom.Point;
	
	import com.kavalok.utils.Timers;
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowCakeAction extends ThrowFightAction
	{
		private static const VELOCITY_MULT:Number = 10;
		private static const MINI_CAKES_ELAST:Number = 0.5;
		private static const MINI_CAKES_OFFSET:Number = 40;
		private static const MINI_CAKES_DAMAGE:uint = 1;
		private static const MINI_CAKES_COUNT:uint = 10;
		private static const GRAVITY_MULT:Number = 0.5;
		private static const START_SPEED:Number = 300;
		private static const DAMAGE:int = 20;

		public function ThrowCakeAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			Global.playSound(SB_3_cake_drop);
			
			var shell:WCakeShell = new WCakeShell();
			shell.mcRect.visible = false;
			var rect:Polygon = PhysicsEngine.createRectangle(shell.mcRect.width, shell.mcRect.height, new Vector2D(0, 0));
			rect.data = this;
			
			var object : PhysicsObject = createPhysicsObject(shell, coords, rect, DAMAGE, START_SPEED, GRAVITY_MULT);
			object.angularVelocity = -2;
		}

		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			super.onCollide(source, target);
			
			source.deleted = true;
			
			if(target is Player)
				return;
				
			playSoundSafe(SB_3_cake_down, 100);
			
			for(var i : uint = 0; i < MINI_CAKES_COUNT; i++)
			{
				var movie : WCakeDestroy = new WCakeDestroy();
				var rect : Circle = new Circle(movie.width / 2, new Vector2D()
					, new Material(MINI_CAKES_ELAST, Config.DEF_FRICTION, Config.DEF_DENSITY));
				var newPosition : Point = source.position.clone();
				newPosition.offset(getRandomOffset(), getRandomOffset());
				var cake : PhysicsObject = createPhysicsObject(movie, newPosition, rect, MINI_CAKES_DAMAGE, 0, GRAVITY_MULT);
				newPosition.offset(- source.position.x, - source.position.y);
				cake.velocity.setTo(newPosition.x * VELOCITY_MULT, newPosition.y * VELOCITY_MULT);
				cake.collideHandler = super.onCollide;
				Timers.callAfter(setCollideHandler, 300, this, [cake]);
			}
		}
		
		private function setCollideHandler(cake : PhysicsObject):void
		{
			cake.collideHandler = onMiniCakeCollide;
		}
		
		private function getRandomOffset():Number
		{
			return Math.random() * MINI_CAKES_OFFSET - MINI_CAKES_OFFSET/2;
		}
		
		private function onMiniCakeCollide(source:PhysicsObject, target : *):void
		{
			if (source.sprite.alpha > 0.9)
				playSoundSafe(SB_z_anithing_down, 100);
			
			super.onCollide(source, target);
			processCollision(source);
		}
		
		private function hideCake(fo:PhysicsObject):void
		{
			if (fo.sprite.width == 0)
			{
				fo.deleted = true;
			}
		}

	}
}