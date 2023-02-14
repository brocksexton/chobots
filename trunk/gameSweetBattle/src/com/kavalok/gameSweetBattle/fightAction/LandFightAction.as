package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.dynamics.Material;

	public class LandFightAction extends FightActionBase
	{
		private static const ITEM : String = "item";
		public var config : Object;
		private var _id : String;
		private var _clip : MovieClip;
		public function LandFightAction(stage:GameStage, player:Player, data:Object)
		{
			super(stage, player, data);
			_id = data.actionId;
			stage.field
			_clip = stage.field[_id];
		}
		
		override public function execute():void
		{
			if(player == null || player.position == null) //added to avoid #2207
				return;
			if(_clip.currentFrame != 1)
				return;
			
			_clip.addEventListener(Event.ADDED, onAdded);
			_clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_clip.play();
		}
		
		private function onEnterFrame(event : Event) : void
		{
			if(_clip.currentFrame == _clip.totalFrames)
			{
				_clip.gotoAndStop(1);
				_clip.removeEventListener(Event.ADDED, onAdded);
				_clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
			}
		}
		private function onAdded(event : Event) : void
		{
			var object : DisplayObject = DisplayObject(event.target);
			if(object.name == ITEM)
			{
				createPhysicsObject(MovieClip(object));
			}
		}

		private function createPhysicsObject(shell : MovieClip) : void
		{
			var fo:PhysicsObject = new PhysicsObject();
			fo.owner = player;
			
			fo.data.damage = config.damage;
			fo.data.times = {};
			fo.addCircle(0.5 * shell.width, 0, 0, new Material(config.elast || 0.99, config.friction || 0.99, Config.DEF_DENSITY));
			
			fo.position = GraphUtils.transformCoords(new Point(), shell, stage.engine.stage);
			shell.x = shell.y = 0;
			fo.setModel(shell);
			
			fo.masslessForce.y = PhysicsEngine.gravity * config.gravityMult;
			
			if(config.speed)
			{
				var values : Array = config.speed.split(",");
				fo.velocity.setTo(values[0], values[1]);
			}
			
			if(config.plateMode)
			{
				fo.body.rotationLocked = true;
			}
			fo.collideHandler = onCollide;
			fo.update();
			
			stage.engine.addObject(fo);
		}
		
		private function onCollide(source:PhysicsObject, target:*):void
		{
			if (target is Player)
				Player(target).makeDamage(source);
			
			source.sprite.alpha -= 0.03;
			if (source.sprite.alpha <= 0)
				source.deleted = true;
			if(config.plateMode)
			{
				source.body.a = Math.atan2(source.velocity.y, source.velocity.x) + 180;
				source.angularVelocity = 0;
			}
		}
	}
}