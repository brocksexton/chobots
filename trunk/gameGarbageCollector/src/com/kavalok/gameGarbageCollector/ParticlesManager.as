package com.kavalok.gameGarbageCollector
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.events.EventSender;
	import com.kavalok.garbageCollector.Garbage5;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.RandomTimer;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.Timers;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class ParticlesManager extends ClientBase
	{
		private static const BONUS_TIME : Number = 10;
		private static const BONUS_QUANTITY : Number = 0.1;
		private static const BONUS_CLASS : Class = Garbage5;
		private static const BONUS_TYPE : uint = 5;
		private static const TYPES : uint = 5;
		private static const MARGINS : Number = 250;
		private static const SPEED : Number = 10;
		private static const GARBAGE_OFFSET : Number = 10;
		private static const FRAMES_PER_TICK : Number = 10;

		public var team : uint;
		
		private var _particles : Dictionary = new Dictionary();
		private var _garbage : Dictionary = new Dictionary();
		private var _bullets : Dictionary = new Dictionary();

		private var _collision : EventSender = new EventSender();
		
		private var _garbageFactory : GarbageFactory = new GarbageFactory();
		private var _bulletsFactory : BulletsFactory = new BulletsFactory();
		private var _content : MovieClip;
		private var _timer : RandomTimer;
		private var _remoteIdToConnect : String;
		private var _bonusMode : Boolean;
		private var _bonusTimer : Timer;
		private var _currentBonusTime : uint = BONUS_TIME;
		
		private var _bonusTime : EventSender = new EventSender();
		
		public function ParticlesManager(content : MovieClip, remoteId : String, quantity : Number)
		{
			_remoteIdToConnect = remoteId;
			_content = content;
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_timer = new RandomTimer(_content, quantity, FRAMES_PER_TICK);
			_timer.tick.addListener(onTick);
			connect(remoteId);
		}
		
		public function get bonusTime() : EventSender
		{
			return _bonusTime;
		}
		public function get collision() : EventSender
		{
			return _collision;
		}
		
		public function start() : void
		{
			_timer.start();
		}
		
		public function sendAddBullet(position : Point, type : uint, angle : Number) : void
		{
			var radians : Number = Maths.degreesToRadians(angle);
			var speed : Point = new Point(Math.cos(radians) * SPEED, Math.sin(radians) * SPEED);
			var localPosition : Point = _content.globalToLocal(position);
			var particle : Particle = new Particle(localPosition, type, speed);
			particle.owner = clientCharId;
			send("rAddBullet", particle);
			var movie : MovieClip = doAddBullet(particle);
			_bullets[particle.id] = new ParticleItem(particle, movie);
		}
		
		public function rAddBullet(particle : Object) : void
		{
			var castedParticle : Particle = Particle.fromObject(particle);
			if(castedParticle.owner != clientCharId)
			{
				doAddBullet(castedParticle);
			}
		}
		public function rAddGarbage(particle : Object) : void
		{
			var castedParticle : Particle = Particle.fromObject(particle);
			var movie : MovieClip = _garbageFactory.createParticle(castedParticle.type);
			var item : ParticleItem = doAddParticle(castedParticle, movie);
			_garbage[particle.id] = item;
		}

		public function doAddBullet(particle : Particle) : MovieClip
		{
			var movie : MovieClip = _bulletsFactory.createParticle(particle.type);
			movie.rotation = Maths.radiansToDegrees(Math.atan2(particle.speed.y, particle.speed.x));
			doAddParticle(particle, movie);
			return movie;
		}
		public function doAddParticle(particle : Particle, movie : MovieClip) : ParticleItem
		{
			_content.addChild(movie);
			movie.x = particle.position.x;
			movie.y = particle.position.y;
			var item : ParticleItem = new ParticleItem(particle, movie);
			_particles[particle.id] = item;
			return item;
		}
		
		private function onTick() : void
		{
			var x : Number = MARGINS + GARBAGE_OFFSET +  Math.random() * (_content.width - MARGINS * 2);
			var type : uint = Math.random()* TYPES + 1;
			type = Math.min(TYPES, type);
			if(type == BONUS_TYPE && Math.random() > BONUS_QUANTITY)
				return;

			var speed : Number = Math.random() * SPEED;
			var particle : Particle = new Particle(new Point(x, 0), type, new Point(0, speed));
			send("rAddGarbage", particle);
		}
		
		private function onEnterFrame(event : Event) : void
		{
			moveParticles();
			checkCollisions();
		}
		private function checkCollisions() : void
		{
			var bulletsToRemove : ArrayList = new ArrayList();
			var garbageToRemove : ArrayList = new ArrayList();
			for(var key : String in _bullets)
			{
				var bullet : ParticleItem = _bullets[key];
				if(bullet == null)
					continue;
				for(var garbageKey : String in _garbage)
				{
					var garbage : ParticleItem = ParticleItem(_garbage[garbageKey]);
					if(garbage && (garbage.particle.type == bullet.particle.type || _bonusMode)
						&& garbage.movie.hitTestObject(bullet.movie))
					{
						garbageToRemove.addItem(garbageKey);
						bulletsToRemove.addItem(key);
						collision.sendEvent();
					}
				}
			}
			var id : String;
			for each(id in garbageToRemove)
			{
				sendRemoveParticle(id, team);
			}
			for each(id in bulletsToRemove)
			{
				if(_bullets[id])
					_bullets[id] = null;
				
				sendRemoveParticle(id, team);
			}
		}

		private function startBonusMode() : void
		{
			if(_bonusTimer != null)
			{
				_bonusTimer.stop();
				_bonusTimer.removeEventListener(TimerEvent.TIMER, onBonusTimer);
				_bonusTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onBonusTimerComplete);
			}
			_bonusTimer = new Timer(1000, BONUS_TIME);
			_currentBonusTime = BONUS_TIME;
			bonusTime.sendEvent(_currentBonusTime);
			_bonusTimer.addEventListener(TimerEvent.TIMER, onBonusTimer);
			_bonusTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onBonusTimerComplete);
			_bonusTimer.start();
			_bonusMode = true;
		}
		private function onBonusTimerComplete(event : TimerEvent) : void
		{
			_bonusMode = false;
		}
		private function onBonusTimer(event : TimerEvent) : void
		{
			_currentBonusTime--;
			bonusTime.sendEvent(_currentBonusTime);
		}
		private function sendRemoveParticle(id : String, team : uint) : void
		{
			send("rRemoveParticle", clientCharId, id, team);
			removeParticle(id, team);
		}
		public function rRemoveParticle(char : String, id : String, team : uint) : void
		{
			if(clientCharId != char)
			{
				removeParticle(id, team);
			}
		}
		private function removeParticle(id : String, team : uint) : void
		{
			var particle : ParticleItem = ParticleItem(_particles[id]);
				
			if(particle != null)
			{
				if(this.team == team && (particle.movie is BONUS_CLASS))
					startBonusMode();
				var isGarbage : Boolean;
				if(_garbage[id])
				{
					_garbage[id] = null;
					isGarbage = true;
				}
				_particles[id] = null;
				if(particle.movie != null)
				{
					if(isGarbage)
					{
						particle.movie.gotoAndStop(2);
						Timers.callAfter(_content.removeChild, 200, _content, [particle.movie]);
					}
					else
					{
						_content.removeChild(particle.movie);
					}
				}
			}
		}
		private function moveParticles() : void
		{
			var keysToRemove : ArrayList = new ArrayList();
			for(var key : String in _particles)
			{
				var item : ParticleItem = _particles[key];
				if(item == null)
					continue;
				item.movie.x += item.particle.speed.x;
				item.movie.y += item.particle.speed.y;
				var coord : Point = item.movie.localToGlobal(new Point(0,0));
				if(!_content.content.hitTestPoint(coord.x, coord.y, true))
				{
					_content.removeChild(item.movie);
					keysToRemove.addItem(key);
				}
			}
			
			for each(var keyToRemove : String in keysToRemove)
			{
				_particles[keyToRemove] = null;
				if(_garbage[keyToRemove])
				{
					_garbage[keyToRemove] = null;
				}
				if(_bullets[keyToRemove] == null)
				{
					_bullets[keyToRemove]= null;
				}
			}
		}
		
		public function destroy():void
		{
			_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_timer.stop();
		}

	}
}
	import com.kavalok.gameGarbageCollector.Particle;
	import flash.display.MovieClip;
	

internal class ParticleItem
{
	public var particle : Particle;
	public var movie : MovieClip;
	
	public function ParticleItem(particle : Particle, movie : MovieClip)
	{
		this.particle = particle;
		this.movie = movie;
	}
}