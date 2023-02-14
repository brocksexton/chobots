package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	import flash.geom.Point;

	public class ThrowRoAction extends ThrowFightAction
	{
		private static const GRAVITY_MULT:Number = 1;
		private static const START_SPEED:Number = 500;
		private static const DAMAGE:int = 3;

		public function ThrowRoAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override protected function createShell(shellClass:Class, coords:Point):void 
		{
			var shell:WRoShell = new WRoShell();
			
			var fo:PhysicsObject = new PhysicsObject();
			fo.owner = player;
			fo.setModel(shell);
			fo.addCircle(0.5*shell.width);
			
			fo.data.damage = DAMAGE;
			fo.data.times = {};
			fo.position = coords;
			fo.velocity.x = START_SPEED * _sightPower * Math.cos(_sightRotation);
			fo.velocity.y = START_SPEED * _sightPower * Math.sin(_sightRotation);
			
			fo.masslessForce.y = Config.GRAVITY * GRAVITY_MULT;
			
			fo.collideHandler = onCollide;
			fo.update();
			
			stage.engine.addObject(fo);
		}
		
		override protected function onCollide(source:PhysicsObject, target:*):void
		{
			if (target is Player) 
				Player(target).makeDamage(source);
			
			source.collideHandler = null;
			source.stepHandler = hideBrick;
		}
		
		private function hideBrick(fo:PhysicsObject):void
		{
			fo.sprite.alpha -= 0.1;
				
			if (fo.sprite.alpha <= 0) 
				fo.deleted = true;
		}
		

	}
}