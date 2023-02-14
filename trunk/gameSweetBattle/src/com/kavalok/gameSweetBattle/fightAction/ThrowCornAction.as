package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_9_popkorn_down;
	import com.kavalok.gameSweetBattle.SB_9_popkorn_drop;
	import com.kavalok.Global;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowCornAction extends ThrowFightAction
	{
		private const STATE_UP:String = 'up';
		private const STATE_DOWN:String = 'down';
		private const STATE_CLOSE:String = 'close';
		private const STATE_IDLE:String = 'idle';
		private const STATE_FLY:String = 'fly';
		private const STATE_HIDE:String = 'hide';

		private static const CORN_COUNT:int = 8;
		private static const GRAVITY_MULT:Number = 0.4;
		private static const START_SPEED:Number = 500;
		private static const DAMAGE:int = 5;

		public function ThrowCornAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			Global.playSound(SB_9_popkorn_drop);
			
			var movie : MovieClip = new WCornShell();
			var shape : Circle = new Circle(0.4 * movie.width, new Vector2D(0, 0));
			var object : PhysicsObject = createPhysicsObject(movie, coords, shape, DAMAGE, START_SPEED, GRAVITY_MULT);

			if (object.velocity.y < 0)
				object.state = STATE_UP;
			else
				object.state = STATE_IDLE;
		}
		
		private function createPopCorn(coords:Point):void
		{
			for (var i:int = 0; i < CORN_COUNT; i++)
			{
				var shell:WCornShellPop = new WCornShellPop();
				var shape : Circle = new Circle(shell.width, new Vector2D(0,0));
				var object : PhysicsObject = createPhysicsObject(shell, new Point(coords.x + i % 2, coords.y + i % 2), shape, DAMAGE, 0, GRAVITY_MULT);
				object.elast = 0.9;
				object.data.times = {};
				object.velocity.x = -100 + (i % 2) * 200;
				object.velocity.y = -100 + (i % 2) * 200;

				object.collideHandler = onPopCornCollide;
				object.update();
				object.state = STATE_DOWN;
				
			}
		}
		
		private function onPopCornCollide(source:PhysicsObject, target:*):void
		{
			if (source.state == STATE_DOWN && target is Player)
			{
				Player(target).makeDamage(source);
				source.sprite.scaleX = source.sprite.scaleY = source.sprite.scaleX - 0.1;
			}
			
			if (target == undefined)
			{
				source.sprite.scaleX = source.sprite.scaleY = source.sprite.scaleX - 0.02;
			}
					
			Circle(source.body.memberShapes[0]).r = source.sprite.width * 0.4;
					
			if (source.sprite.scaleX < 0.3)
			{
				source.deleted = true;
			}
		}

		override protected function onStep(object:PhysicsObject):void
		{
			if (object.state == STATE_UP)
			{
				if (object.velocity.y > 0 || object.position.y < 0)
				{
					Global.playSound(SB_9_popkorn_drop);
					object.setModelClass(WCornOpen);
					object.rotation = 0;
					object.angularVelocity = 0;
					object.velocity.x = 0;
					object.velocity.y = 60;
					object.masslessForce.y = 0;
					object.state = STATE_DOWN;
				}
			}
			else if (object.state == STATE_HIDE)
			{
				object.sprite.alpha -= 0.1;
				if (object.sprite.alpha <= 0)
				{
					object.deleted = true;
				}
			}
			else if (object.state == STATE_CLOSE)
			{
				if (object.sprite.width == 0)
				{
					object.deleted = true;
					createPopCorn(object.position);
				}
			}
		}
		
		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			playSoundSafe(SB_9_popkorn_down);
			
			if (source.state == STATE_UP || source.state == STATE_IDLE)
			{
				super.onCollide(source, target);
				source.state = STATE_HIDE;
			}
			else if (source.state == STATE_DOWN)
			{
				source.setModelClass(WCornShellClose);
				source.state = STATE_CLOSE;
			}
		}
	}
}