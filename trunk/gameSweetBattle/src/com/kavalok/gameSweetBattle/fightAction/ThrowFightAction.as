package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.actions.ThrowConfig;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.dynamics.RigidBody;

	public class ThrowFightAction extends FightActionBase
	{
		protected var _sightRotation:Number;
		protected var _sightPower:Number;
		
		protected var config : ThrowConfig;

		public function ThrowFightAction(stage : GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
		}
		
		public function set throwConfig(value : ThrowConfig) : void
		{
			config = value;
		}
	
		override public function execute():void
		{
			if(player == null)
				return;
			_sightRotation = data.sightDirection;
			_sightPower = data.power;
			
			player.direction = data.playerDirection;
			player.setModelClass(config.fightModel);
			
			stage.em.registerEvent(player, Event.ADDED, onShellAdded);
		}
		
		protected function createShell(shellClass:Class, coords:Point):void {}

		protected function createStaticObject(movie : MovieClip, coords : Point, shape : GeometricShape, damage : Number) : PhysicsObject
		{
			var object:PhysicsObject = new PhysicsObject(RigidBody.STATIC_BODY);
			configurePhysicsObject(object, movie, coords, shape, damage);
			return object;
		}
		
		protected function createPhysicsObject(movie : MovieClip, coords : Point, shape : GeometricShape, damage : Number, startSpeed : Number, gravityMult : Number) : PhysicsObject
		{
			var object:PhysicsObject = new PhysicsObject();
						
			
			object.rotation = Maths.degreesToRadians(movie.rotation);
			object.data.times = {};
			object.velocity.x = startSpeed * _sightPower * Math.cos(_sightRotation);
			object.velocity.y = startSpeed * _sightPower * Math.sin(_sightRotation);
			
			object.angularVelocity = 5;
			object.masslessForce.y = PhysicsEngine.gravity * gravityMult;
			
			configurePhysicsObject(object, movie, coords, shape, damage);
			
			return object;
		}
		private function configurePhysicsObject(object : PhysicsObject, movie : MovieClip, coords : Point, shape : GeometricShape, damage : Number) : void
		{
			object.owner = player;
			object.setModel(movie);
			object.body.addShape(shape);
			shape.data = object;
			
			object.data.damage = damage;
			object.position = coords;
			object.stepHandler = onStep;
			object.collideHandler = onCollide;
			object.update();
			
			stage.engine.addObject(object);
			
		}
		
		protected function onStep(object:PhysicsObject):void {}
		protected function processCollision(source:PhysicsObject, diff : Number = 0.02):void 
		{
			source.sprite.alpha -= diff;
			if(source.sprite.alpha <= 0)
			{
				source.deleted = true;
			}
		}
		protected function onCollide(source:PhysicsObject, target:*):void 
		{
			if (target is Player) 
			{
				Player(target).makeDamage(source);
			}
		}
		
		protected function onShellAdded(e:Event):void
		{
			var player : Player = Player(e.currentTarget);
			var d:DisplayObject = DisplayObject(e.target)
			
			if (d is StopMarker)
			{
				stage.em.removeEvent(player, Event.ADDED, onShellAdded);
				player.setModelClass(config.showModel);
				if(player.isUser)
				{
					stage.selectDefaultAction();
//					stage.unLockActions();
				}
			}
			
			for each (var shellClass:Class in config.shellModels)
			{
				if (d is shellClass)
				{
					var coords:Point = new Point(0, 0);
					
					GraphUtils.transformCoords(coords, d, stage.engine.stage);
					
					createShell(shellClass, coords);
					
				}
			}

		}
		
		
	}
}