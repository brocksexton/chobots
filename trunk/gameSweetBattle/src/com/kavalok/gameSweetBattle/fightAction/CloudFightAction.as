package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.Global;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.SB_8_salt_down;
	import com.kavalok.gameSweetBattle.SB_8_salt_drop;
	import com.kavalok.gameSweetBattle.SB_8_salt_move;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class CloudFightAction extends FightActionBase
	{
		public static const DAMAGE:int = 2;
		private static const GRAVITY_MULT:Number = 0.3;
		private static const SHELL_COUNT:int = 25;
		private static const CLOUD_SPEED:int = 5;

		private var _targetPos : Number;
		private var _cloud:WPepper;
		
		public function CloudFightAction(stage : GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		override public function execute():void
		{
			if(player == null || player.position == null) //added to avoid #2207
				return;
			Global.playSound(SB_8_salt_move);
			
			_targetPos = data.x;
			
			_cloud = new WPepper();
			_cloud.x = player.position.x;
			_cloud.y = 0;
			_cloud.cacheAsBitmap = true;
			stage.field.addChild(_cloud);
			
			stage.em.registerEvent(_cloud, Event.ENTER_FRAME, moveVertical);
			if(player.isUser)
				stage.selectDefaultAction();
			
		}

		private function moveVertical(e:Event):void
		{
			_cloud.y += CLOUD_SPEED;
			
			if (_cloud.y > _cloud.height * 0.7)
			{
				stage.em.removeEvent(_cloud, Event.ENTER_FRAME, moveVertical);
				stage.em.registerEvent(_cloud, Event.ENTER_FRAME, moveHorizontal);
			}
		}
		
		private function moveHorizontal(e:Event):void
		{
			var direction:int = (_cloud.x < _targetPos) ? 1 : -1;
			_cloud.x += CLOUD_SPEED * direction;
			
			if (Math.abs(_cloud.x - _targetPos) < 2 * CLOUD_SPEED)
			{
				Global.playSound(SB_8_salt_drop);
				
				stage.em.removeEvent(_cloud, Event.ENTER_FRAME, moveHorizontal);
				stage.em.registerEvent(_cloud, Event.ENTER_FRAME, removeCloud);
				
				for (var i:int = 0; i < SHELL_COUNT; i++)
				{
					createShell(i);
				}
				
			}
		}
		
		private function removeCloud(e:Event):void
		{
			_cloud.alpha -= 0.1;
			
			if (_cloud.alpha <= 0)
			{
				stage.em.removeEvent(_cloud, Event.ENTER_FRAME, removeCloud);
				stage.field.removeChild(_cloud);
			}
		}
		
		private function createShell(num:int):void
		{
			var shell:WPepperShell = new WPepperShell();
			
			var fo:PhysicsObject = new PhysicsObject();
			fo.owner = player;
			fo.setModel(shell);
			
			fo.data.damage = DAMAGE;
			fo.data.times = {};
			fo.friction = 0.1;
			fo.elast = 0.99;
			//fo.body.setMoment(500);
			//fo.body.setMass(Config.DEF_MASS * 0.2);
			fo.addCircle(0.5 * shell.width);
			
			var rows : Number = int(Math.sqrt(SHELL_COUNT));
			var x:Number = _cloud.x - 0.7 * _cloud.width + 1.4 * _cloud.width * num / SHELL_COUNT;
			var y:Number = _cloud.y + (num % 3 ) * 7;
			
			fo.position = new Point(x, y);
			
			fo.masslessForce.y = PhysicsEngine.gravity * GRAVITY_MULT;
			
			fo.collideHandler = onCollide;
			fo.update();
			
			stage.engine.addObject(fo);
		}
		
		private function onCollide(source:PhysicsObject, target:*):void
		{
			if (source.sprite.alpha > 0.9)
				playSoundSafe(SB_8_salt_down, 100);
			
			if (target is Player)
				Player(target).makeDamage(source);
			
			source.sprite.alpha -= 0.03;
			if (source.sprite.alpha <= 0)
				source.deleted = true;
		}
		
		
	}
}