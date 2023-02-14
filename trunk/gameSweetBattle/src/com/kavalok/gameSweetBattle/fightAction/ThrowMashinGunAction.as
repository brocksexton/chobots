package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.SB_4_balls_shot;
	import com.kavalok.Global;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.math.Vector2D;

	public class ThrowMashinGunAction extends ThrowFightAction
	{
		private static const COUNT:Number = 10;
		private static const GRAVITY_MULT:Number = 0;
		private static const START_SPEED:Number = 500;
		private static const DAMAGE:int = 2;
		
		private var _currentCount : uint = 0;

		public function ThrowMashinGunAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void
		{
			var shell:WMashinGunShell = new WMashinGunShell();
			var circle : Circle = new Circle(shell.width, new Vector2D());
			createPhysicsObject(shell, coords, circle, DAMAGE, START_SPEED, GRAVITY_MULT);
		}
		
		override protected function onShellAdded(e:Event):void
		{
			if (_currentCount == 0)
				Global.playSound(SB_4_balls_shot);
			
			super.onShellAdded(e);
			var player : Player = Player(e.currentTarget);
			var object:DisplayObject = DisplayObject(e.target)
			if(object is WMashinGunShell)
			{
				_currentCount++;
				if(_currentCount <= COUNT)
				{
					player.setModelClass(WMashinGunFight);
				}
			}
		}

		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			super.onCollide(source, target);
			source.deleted = true;
		}
	}
}