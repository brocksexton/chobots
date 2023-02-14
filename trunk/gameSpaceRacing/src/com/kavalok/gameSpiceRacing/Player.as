package com.kavalok.gameSpiceRacing
{
	import com.kavalok.games.GameObject;
	import com.kavalok.gameSpiceRacing.bonuses.BioBonus;
	import com.kavalok.gameSpiceRacing.bonuses.BonusBase;
	import com.kavalok.gameSpiceRacing.bonuses.FuelBonus;
	import com.kavalok.gameSpiceRacing.bonuses.SlowBonus;
	import com.kavalok.gameSpiceRacing.bonuses.SpeedBonus;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import com.kavalok.utils.Objects;
	import com.kavalok.utils.ReflectUtil;

	public class Player
	{
		private static const BONUSES:Dictionary = new Dictionary();;
		BONUSES[McSpeedItem] = SpeedBonus;
		BONUSES[McSlowItem] = SlowBonus;
		BONUSES[McFuelItem] = FuelBonus;
		BONUSES[McBioItem] = BioBonus;
		
		public var id:String;
		public var model:McPlayer;
		public var space:Space;
		public var marker:McPlayerMarker;
		
		public var body:GameObject;
		
		public var maxAccX:Number = 2;
		public var maxAccY:Number = 2;
		public var fuel:Number = 1;
		public var fuelKoef:Number;
		public var time:Number;
		public var atFinish:Boolean = false;
		
		private var _bonus:BonusBase;
		private var _minX:int;
		private var _maxX:int;
		
		public function Player(id:String, modelNum:int, space:Space)
		{
			this.id = id;
			this.space = space;
			
			model = new McPlayer();
			model.mcCenter.gotoAndStop(modelNum + 1);
			model.mcSide.gotoAndStop(modelNum + 1);
			
			marker = new McPlayerMarker();
			marker.gotoAndStop(modelNum + 1);
			
			body = new GameObject(model);
			body.dcc.x = 0.98;
			body.dcc.y = 0.98;
			body.radius = 0.5 * model.mcArea.width;
			
			model.mcArea.visible = false;
			
			_minX = 0.5 * model.width;
			_maxX = space.pageWidth - 0.5 * model.width;
			
			fuelKoef = Config.FUEL_KOEF;
		}
		
		public function control():void
		{
			var kx:Number = GraphUtils.claimRange(model.mouseX / 150, -1, 1);
			var ky:Number = GraphUtils.claimRange(model.mouseY / 150, -1, 0);
			
			body.acc.x = maxAccX * kx;
			body.acc.y = maxAccY * ky;
			
			if (fuel == 0)
				body.acc.mulScalar(Config.FUEL_EMPTY_KOEF);
		}
		
		public function setFire(fireNum:int):void
		{
			model.mcFire.gotoAndStop(fireNum + 1);
		}
		
		public function hideFire():void
		{
			model.mcFire.gotoAndStop(model.mcFire.totalFrames);
		}
		
		public function move():void
		{
			body.processMov();
			
			if (model.x < _minX)
			{
				model.x = _minX;
				body.v.x = -body.v.x;
			}
			else if (model.x > _maxX)
			{
				model.x = _maxX;
				body.v.x = -body.v.x;
			}
		}
		
		public function checkColisions():void
		{
			for each (var item:GameObject in space.items)
			{
				if (!item.content.visible)
					continue;
					
				if (body.collideWith(item) && !item.tag.used)
				{
					var itemType:Class = getDefinitionByName(getQualifiedClassName(item.content)) as Class;
					if (itemType in BONUSES)
					{
						createBonus(BONUSES[itemType]);
						removeItem(item);
					}
					else
					{
						Global.playSound(snd_hit_rock);
						body.resolve(item);
					}
					
					break;
				}
			}
		}
		
		private function removeItem(item:GameObject):void
		{
			var twean:Object = { scaleX : 0, scaleY : 0 };
			var tweaner:SpriteTweaner = new SpriteTweaner(item.content, twean, 10);
		}
		
		private function createBonus(bonusClass:Class):void
		{
			if (_bonus)
				_bonus.destroy();
			_bonus = new bonusClass();
			_bonus.player = this;
			_bonus.execute();
		}
		
		public function processFuel():void
		{
			body.dcc.x = body.dcc.y = 1 - body.v.magnitude() * Config.SPACE_DCC;
			
			fuel -= body.v.magnitude2() * fuelKoef;
			
			if (fuel < 0)
				fuel = 0;
		}
		
		public function moveTo(x:int, y:int):void
		{
			body.v.x = 2 * (x - model.x) / Config.UPDATE_INTERVAL / model.stage.frameRate;
			body.v.y = 2 * (y - model.y) / Config.UPDATE_INTERVAL / model.stage.frameRate;
		}
		
		public function destroy():void
		{
			hideFire();
			if (_bonus)
				_bonus.destroy();
		}
		
	}
	
}
