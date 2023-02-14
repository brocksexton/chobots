package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.char.LocationChar;
	import com.kavalok.constants.ClientIds;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.commands.MoveCharCommand;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.robots.CombatParameters;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class RobotCombatEntry extends ClientBase
	{
		static public const CLIP_NAME:String = 'robotCombat';
		
		private var _content:Sprite;
		private var _location:LocationBase;
		
		private var _entries:Array = [];
		private var _locked:Boolean = false;
		private var _playerNum:int;
		private var _maxLevel:int;
		
		public function RobotCombatEntry(content:Sprite, location:LocationBase)
		{
			_content = content;
			_location = location;
			_location.readyEvent.addListener(onLocationReady);
			readConfig();
			createEntries();
		}
		
		private function readConfig():void
		{
			var configString:String = GraphUtils.getConfigString(_content, 'configField');
			var config:Object = Strings.getParameters(configString);
			if ('maxLevel' in config)
				_maxLevel = parseInt(config['maxLevel']);
			else
				_maxLevel = 0;
		}
		
		override public function get id():String
		{
			return ClientIds.ROBOT_COMBAT;
		}
		
		private function onLocationReady():void
		{
			connect(_location.remoteId);
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			refresh();
		}
		
		private function refresh():void
		{
			for (var i:int = 0; i < _entries.length; i++)
			{
				if (playerExists(i))
					getEntryClip(i).gotoAndStop(3);
				else
					getEntryClip(i).gotoAndStop(1);
			}
		}
		
		private function onGoIn(entry:SpriteEntryPoint):void
		{
			if ( Global.charManager.hasRobot && Global.charManager.robot.level)
			
			if (!Global.charManager.hasRobot)
			{
				Dialogs.showOkDialog(Global.resourceBundles.robots.messages.haveNotRobot);
			}
			else
			{
				if (_maxLevel > 0 && Global.charManager.robot.level > _maxLevel)
				{
					var message:String = Strings.substitute(
						Global.resourceBundles.robots.messages.levelLimit, _maxLevel);
					Dialogs.showOkDialog(message);
				}
				else
				{
					_playerNum = _entries.indexOf(entry);
					var stateName:String = getPlayerStateId(_playerNum);
					var state:Object = { charId: Global.charManager.charId }; 
					sendState('rLock', stateName, state, true);
				}
			}
		}
		
		public function rLock(stateId:String, state:Object):void
		{
			if (!locked && state.charId == Global.charManager.charId)
			{
				locked = true;
				placeChar();
				send('rReady');
			}
		}
		
		private function placeChar():void
		{
			var position:Point = GraphUtils.transformCoords(new Point(), getEntryClip(_playerNum), _location.content);
			var command:MoveCharCommand = new MoveCharCommand(Global.charManager.charId, position);
			_location.sendCommand(command);
			_location.sendUserModel(CharModels.STAY, Directions.DOWN);
		}
		
		private function onGoOut(entry:SpriteEntryPoint):void
		{
			if (locked)
			{
				locked = false;
				removeState('rRemove', getPlayerStateId(_playerNum)); 
			}
		}
		
		override public function charDisconnect(charId:String):void
		{
			refresh();
		}
		
		public function rRemove(stateId:String):void
		{
			refresh();
		}
		
		public function rReady():void
		{
			refresh();
			if (locked && playerExists(0) && playerExists(1))
			{
				getEntry(_playerNum).goOut();
				if (Global.charManager.robotTeam.contains(getOpponent().id))
				{
					Dialogs.showOkDialog(Global.resourceBundles.robots.messages.combatNotAllowed);
					var command:MoveCharCommand = new MoveCharCommand(
						Global.charManager.charId, getEntry(_playerNum).position);
					_location.sendCommand(command);
				}
				else
				{
					loadModule();
				}
			}
		}
		
		private function loadModule():void
		{
			_location.sendHideUser();
			var parameters:CombatParameters = new CombatParameters(getOpponent().userId);
			Global.moduleManager.loadModule(Modules.ROBOT_COMBAT, parameters);
		}
		
		private function createEntries():void
		{
			var num:int = 0;
			
			while (getEntryClip(num) != null)
			{
				var entryClip:MovieClip = getEntryClip(num);
				entryClip.gotoAndStop(1);
				MousePointer.registerObject(entryClip, MousePointer.ACTION);
				
				var positionSprite:Sprite = getPosition(num);
				var position:Point = GraphUtils.transformCoords(new Point(), positionSprite, _location.content);
				
				var entry:SpriteEntryPoint = new SpriteEntryPoint(entryClip, position)
				entry.goInEvent.addListener(onGoIn);
				entry.goOutEvent.addListener(onGoOut);
				
				GraphUtils.detachFromDisplay(positionSprite);
				_location.addPoint(entry);
				_entries[num] = entry;
				num++;
			}
		}
		
		// helpers //////////////////////////////////////////////////////////////////////
		
		public function get locked():Boolean { return _locked; }
		public function set locked(value:Boolean):void
		{
			 if (_locked != value)
			 {
				 _locked = value;
				 refresh();
			 }
		}
		
		private function getOpponent():LocationChar
		{
			var opponentNum:int = (_playerNum == 0) ? 1 : 0;
			var state:Object = states[getPlayerStateId(opponentNum)];
			return _location.chars[state.charId];
		}
		
		private function playerExists(playerNum:int):Boolean
		{
			var state:Object = states[getPlayerStateId(playerNum)];
			if (state)
				return Boolean(remote.connectedChars.indexOf(state.charId) >= 0);
			else
				return false;
		}
		
		private function getPlayerStateId(playerNum:int):String
		{
			return 'player' + playerNum;
		}
		
		private function getEntryClip(playerNum:int):MovieClip
		{
			return _content.getChildByName('entryClip' + playerNum) as MovieClip;
		}
		
		private function getPosition(playerNum:int):Sprite
		{
			return _content.getChildByName('position' + playerNum) as Sprite;
		}
		
		private function getEntry(playerNum:int):SpriteEntryPoint
		{
			return _entries[playerNum];
		}
	}
}