package com.kavalok.gameGarbageCollector
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.EntryPointBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import com.kavalok.flash.geom.Point;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.Timers;

	public class WeaponEntryPoint extends EntryPointBase
	{
		private static const SOUNDS : Array = [SoundShot1, SoundShot2, SoundShot3, SoundShot4, SoundShot5 ];
		private static const SHOOT_INTERVAL : Number = 1000;

		public var particlesManager : ParticlesManager;
		public var team : uint;
		
		private var _lastShotTime : Date = new Date();

		private var _gameLocation : LocationBase;
		private var _userWeapon : MovieClip;
		private var _remoteIdToConnect : String;
		
		
		public function WeaponEntryPoint(remoteId:String, location : LocationBase)
		{
			super(location, "weapon_", remoteId);
			_gameLocation = location;
			_remoteIdToConnect = remoteId;
		}
		
		private function get weaponTarget() : MovieClip
		{
			return MovieClip(_gameLocation.content).weaponTarget;
		}
		
		override public function initialize(mc:MovieClip):void
		{
			MousePointer.registerObject(mc, MousePointer.ACTION);
			mc.charContainer.char.visible = false;
			mc.charContainer.bulletEntry.visible = false;
			mc.charContainer.weapon.stop();
			if(getTeam(mc) == 2)
			{
				mc.charContainer.rotation += 180;
			}
		}
		
		
		override public function goIn():void
		{
			if(getTeam(clickedClip) != team)
				return;
			super.goIn();
			sendState("rCharUseWeapon", clickedClip.name, {char : clientCharId}, true);
		}
		
		override public function goOut():void
		{
			super.goOut();
			if(_userWeapon != null)
			{
				sendState("rCharUnuseWeapon", _userWeapon.name, {char : clientCharId});
				_userWeapon = null;
			}
		}
		
		public function rCharUseWeapon(weaponName : String, state : Object) : void
		{
			var weapon : MovieClip = _gameLocation.content[weaponName];
			weapon.charContainer.char.visible = true;
			if(state.char == clientCharId)
			{
				weaponTarget.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				weaponTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_userWeapon = weapon;
				_gameLocation.sendHideUser();
				updateRotation();
			}
		}
		
		public function rCharUnuseWeapon(weaponName : String, state : Object) : void
		{
			var weapon : MovieClip = _gameLocation.content[weaponName];
			weapon.charContainer.char.visible = false;
			if(state.char == clientCharId)
			{
				weaponTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				weaponTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_gameLocation.sendShowUser();
			}
		}
		
		public function rShoot(weaponName : String, char : String, rotation : Number) : void
		{
			if(clientCharId != char)
			{
				var type : uint = getType(getWeapon(weaponName)) - 1;
				Global.playSound(SOUNDS[type]);
				getWeapon(weaponName).charContainer.weapon.play();
				Timers.callAfter(getWeapon(weaponName).charContainer.weapon.stop, 400);
				getWeapon(weaponName).charContainer.rotation = rotation;
			}
		}
		
		
		private function getWeapon(weaponName : String) : MovieClip
		{
			return _gameLocation.content[weaponName];
		}
		
		private function onMouseDown(event : MouseEvent) : void
		{
			if(_userWeapon == null)
				return;
				
			var now : Date = new Date();
			if(now.time - _lastShotTime.time > SHOOT_INTERVAL)
			{
				_userWeapon.charContainer.weapon.play();
				Timers.callAfter(_userWeapon.charContainer.weapon.stop, 400);
				var position : Point = new Point(_userWeapon.charContainer.bulletEntry.x, _userWeapon.charContainer.bulletEntry.y);
				var globalPosition : Point = Point.fromPoint(MovieClip(_userWeapon.charContainer).localToGlobal(position));
				particlesManager.sendAddBullet(globalPosition, getType(_userWeapon), _userWeapon.charContainer.rotation - 90);
				send("rShoot", _userWeapon.name, clientCharId, _userWeapon.charContainer.rotation);
				Global.playSound(SOUNDS[getType(_userWeapon) - 1]);

				_lastShotTime = now;
			}
		}
		private function getTeam(weapon : MovieClip) : uint
		{
			var parts : Array = weapon.name.split("_");
			return uint(parts[2]);
		}
		private function getType(weapon : MovieClip) : uint
		{
			var parts : Array = weapon.name.split("_");
			return uint(parts[1]);
		}
		private function onMouseMove(event : MouseEvent) : void
		{
			updateRotation();
		}
		
		private function updateRotation() : void
		{
			if(_userWeapon == null)
				return;
			if(weaponTarget.hitTestPoint(Global.root.mouseX, Global.root.mouseY, true))
			{
				var angle : Number = Math.atan2(_userWeapon.y - _gameLocation.content.mouseY, _userWeapon.x - _gameLocation.content.mouseX);
				_userWeapon.charContainer.rotation = Maths.radiansToDegrees(angle) - 90;
			}
		}
		
	}
}