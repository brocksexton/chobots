package com.kavalok.missionFarm
{
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.remoting.RemoteObjects;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class BadChars extends ClientBase
	{
		static private const SPEED:int = 2;
		
		static public const STATE_MOVE:String = 'move';
		static public const STATE_HIDE:String = 'hide';
		static public const STATE_WAIT:String = 'wait';
		static public const STATE_IDLE:String = 'idle';
		
		private var _farm:FarmStage;
		private var _em:EventManager = MissionFarm.eventManager;
		private var _badChars:Object = {};
		
		public function BadChars(farm:FarmStage)
		{
			_farm = farm;
			RemoteObjects.instance.addClient(_farm.remoteId, this);
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			_em.registerEvent(_farm.content, Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function refresh():void
		{
			for each (var badChar:BadChar in _badChars)
			{
				badChar.refresh();
			}
		}
		
		private function onEnterFrame(e:Event):void
		{
			for each (var badChar:BadChar in _badChars)
			{
				processBadChar(badChar);
			}
		}
		
		public function sendCreateBadChar(grow:Grow):void
		{
			var badCharId:String = Strings.generateRandomId();
			var coords:Point = GraphUtils.getRandomZonePoint(_farm.location.ground, _farm.location);
			
			var badCharData:Object =
			{
				owner : clientCharId,
				id : badCharId,
				x : coords.x,
				y : coords.y,
				gId : grow.id,
				gx : grow.model.x,
				gy : grow.model.y
			}

			send('rCreateBadChar', badCharData);
		}
		
		public function rCreateBadChar(data:Object):void
		{
			var dist:int = GraphUtils.distance(new Point(data.x, data.y), new Point(data.gx, data.gy));
			
			var badChar:BadChar = new BadChar();
			
			badChar.farm = _farm;
			badChar.owner = data.owner;
			badChar.em = _em;
			badChar.id = data.id;
			badChar.x = data.x;
			badChar.y = data.y;
			badChar.growId = data.gId;
			badChar.counter = dist / SPEED;
			badChar.vx = (data.gx - data.x) / badChar.counter;
			badChar.vy = (data.gy - data.y) / badChar.counter;
			
			badChar.fightEvent.addListener(onFight);
			badChar.completeEvent.setListener(beginMoveBadChar);
			
			badChar.setModel(McBadCharShow);
			
			_badChars[data.id] = badChar;
			
			_farm.charContainer.addChild(badChar);
		}
		
		private function onFight(badChar:BadChar):void
		{
			var dx:Number = badChar.x - _farm.user.position.x;
			var dy:Number = badChar.y - _farm.user.position.y;
			var direction:int = Directions.getDirection(dx, dy);
			
			_farm.user.setModel(Models.FIGHT, direction);
			var laser:Sprite = _farm.user.model.content.getChildByName('hitClip') as Sprite;
			if (!laser)
				return;
				
			var isHit:Boolean = badChar.hitTestObject(laser);
			_farm.user.setModel(CharModels.STAY);
			
			_farm.sendUserPos(_farm.user.position);
			_farm.sendUserModel(Models.FIGHT, direction);
			
			if (isHit && badChar.state != STATE_HIDE)
			{
				_farm.sendBonus(FarmStage.BAD_CHAR_VALUE);
				badChar.state = STATE_HIDE;
				removeState('rBubble', badChar.id);
			}
		}
		
		private function beginMoveBadChar(badChar:BadChar):void
		{
			if (badChar.vy > 0)
				badChar.setModel(McBadCharFront);
			else
				badChar.setModel(McBadCharBack);
				
			if (badChar.vx < 0)
				badChar.model.scaleX *= -1;
			
			badChar.model.cacheAsBitmap = true;
			badChar.state = STATE_MOVE;
			badChar.refresh();
		}
		
		private function processBadChar(badChar:BadChar):void
		{
			if (badChar.state == STATE_MOVE)
			{
				badChar.x += badChar.vx;
				badChar.y += badChar.vy;
				
				if (--badChar.counter == 0)
				{
					badChar.state = STATE_WAIT;
					badChar.refresh();
				}
			}
			else if (badChar.state == STATE_WAIT)
			{
				if (badChar.owner == clientCharId)
				{
					badChar.state = STATE_IDLE;
					tryTakeGrow(badChar);
				}
				else if (!(badChar.owner in _farm.chars))
				{
					badChar.state = STATE_HIDE;
					badChar.setModel(McBadCharHide);
					badChar.completeEvent.setListener(onBadCharRemoved);
				}
			}
		}
		
		private function tryTakeGrow(badChar:BadChar):void
		{
			var grow:Grow = _farm.grows.list[badChar.growId];
			
			if (grow && !grow.busy)
			{
				grow.lockEvent.setListener(onGrowLock);
				grow.badChar = badChar;
				_farm.grows.sendRemoveGrow(grow);
			}
			else
			{
				sendHideBadChar(badChar);
			}
		}
		
		private function onGrowLock(grow:Grow):void
		{
			sendHideBadChar(grow.badChar);
		}
		
		private function sendHideBadChar(badChar:BadChar):void
		{
			badChar.state = STATE_HIDE;
			send('rHide', badChar.id)
		}
		
		public function rHide(badCharId:String):void
		{
			if (badCharId in _badChars)
			{
				var badChar:BadChar = _badChars[badCharId];
				badChar.state = STATE_HIDE;
				
				badChar.setModel(McBadCharHide);
				badChar.completeEvent.setListener(onBadCharRemoved);
			}
		}
		
		public function rBubble(stateId:String):void
		{
			if (stateId in _badChars)
			{
				var badChar:BadChar = _badChars[stateId];
				badChar.state = STATE_HIDE;
				
				badChar.setModel(McBadCharBubble);
				badChar.model.y = -30;
				badChar.completeEvent.setListener(onBadCharRemoved);
			}
		}
		
		private function onBadCharRemoved(badChar:BadChar):void
		{
			badChar.clearModel();
			
			GraphUtils.detachFromDisplay(badChar);
			
			delete _badChars[badChar.id];
		}
	}
	
}
