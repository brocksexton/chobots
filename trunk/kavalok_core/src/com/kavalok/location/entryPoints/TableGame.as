package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.LocationChar;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.SpectEntryPoint;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class TableGame extends ClientBase
	{
		static public const CLIP_NAME:String = 'tableGame';
		
		private var _content:Sprite;
		private var _location:LocationBase;
		private var _moduleId:String;
		
		private var _entries:Array = [];
		private var _entrySpect:SpriteEntryPoint;
		private var _playerNum:int;
		private var _moduleRemoteId:String;
		private var _isLocked:Boolean = false;
		private var _playerDirection:Array = [5, 1];
		private var _moduleParameters:Object;
		
		public function TableGame(content:Sprite, location:LocationBase)
		{
			_content = content;
			_location = location;
			
			_moduleParameters = GraphUtils.getParameters(_content, 'description');
			_moduleId = _moduleParameters.moduleId;
			_moduleRemoteId = _moduleParameters.remoteId; 
			
			createPlayerEntries();
			createSpectatorEntry();
			
			_location.readyEvent.addListener(onLocationReady);
		}
		
		override public function get id():String
		{
			return _moduleRemoteId;
		}
		
		private function onLocationReady():void
		{
			connect(_location.remoteId);
			Global.tableGameCloseEvent.addListener(onCloseEvent);
			_content.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStade);
		}
		
		private function onRemovedFromStade(e:Event):void
		{
			Global.tableGameCloseEvent.removeListener(onCloseEvent);
			if (_isLocked)
				Global.tableGameCloseEvent.sendEvent(_moduleRemoteId);
		}
		
		private function onCloseEvent(remoteId:String):void
		{
			if (remoteId == _moduleRemoteId)
				goOut();
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			
			for (var stateId:String in state)
			{
				if (isCharState(stateId))
					rPlaceChar(stateId, state[stateId]);
			}
		}
		
		private function onGoIn(entry:SpriteEntryPoint):void
		{
			if (!connected)
				return;
				
			_playerNum = _entries.indexOf(entry);
			
			if (_playerNum >= 0)
				lockState('rLock', getPlayerStateId(_playerNum));
			else
				loadModule(_playerNum);
		}
		
		public function rLock(stateId:String, state:Object):void
		{
			if (_isLocked || state.owner != clientCharId)
				return;
			
			var state:Object = {playerNum: _playerNum};
			sendUserState('rPlaceChar', state);
			placeChar(clientCharId, state);
			loadModule(_playerNum);
		}
		
		public function rPlaceChar(stateId:String, state:Object):void
		{
			var charId:String = extractCharId(stateId);
			
			if (charId != clientCharId)
				placeChar(charId, state);
		}
		
		private function placeChar(charId:String, state:Object):void
		{
			var playerNum:int = state.playerNum;
			
			var container:Sprite = getContainer(playerNum);
			var place:MovieClip = getPlace(playerNum);
			var char:LocationChar = _location.chars[charId];
			
			char.changeParent(container);
			char.setModel(CharModels.STAY, _playerDirection[playerNum]);
			place.gotoAndStop(2);
		}
		
		private function loadModule(playerNum:int):void
		{
			lock();
			_moduleParameters.playerNum = playerNum;  
			Global.moduleManager.loadModule(_moduleId, _moduleParameters);
		}
		
		private function onGoOut(entry:SpriteEntryPoint):void
		{
			if (_isLocked)
				Global.tableGameCloseEvent.sendEvent(_moduleRemoteId);
		}
		
		private function goOut():void
		{
			unlock();
			
			if (_playerNum >= 0)
			{
				send('rUnplaceChar', clientCharId, _playerNum);
				removeState(null, getCharStateId(clientCharId));
				unlockState(getPlayerStateId(_playerNum));
				unplaceChar(clientCharId, _playerNum);
			}
		}
		
		public function rUnplaceChar(charId:String, playerNum:int):void
		{
			if (charId != clientCharId)
				unplaceChar(charId, playerNum);
		}
		
		private function unplaceChar(charId:String, playerNum:int):void
		{
			var entry:SpriteEntryPoint = _entries[playerNum];
			var place:MovieClip = getPlace(playerNum);
			
			place.gotoAndStop(1);
			
			var char:LocationChar = _location.chars[charId];
			if (char)
				char.restoreParent();
		}
		
		private function createPlayerEntries():void
		{
			var playerNum:int = 0;
			
			while (getPlace(playerNum) != null)
			{
				var place:MovieClip = getPlace(playerNum);
				var point:Sprite = getPoint(playerNum);
				var contener:Sprite = getContainer(playerNum);
				
				GraphUtils.removeChildren(contener);
				place.gotoAndStop(1);
				
				var position:Point = new Point();
				GraphUtils.transformCoords(position, point, _location.content);
				MousePointer.registerObject(place, MousePointer.ACTION);
				
				var entry:SpriteEntryPoint = new SpriteEntryPoint(place, position)
				entry.goInEvent.addListener(onGoIn);
				entry.goOutEvent.addListener(onGoOut);
				
				GraphUtils.detachFromDisplay(point);
				_location.addPoint(entry);
				_entries[playerNum] = entry;
				
				playerNum++;
			}
		}
		
		private function createSpectatorEntry():void
		{
			var spectZone:Sprite = getSpectZone();
			var spectClickArea:Sprite = getSpectArea();
			
			spectZone.visible = false;
			spectClickArea.alpha = 0; 
			
			MousePointer.registerObject(spectClickArea, MousePointer.ACTION);
			
			_entrySpect = new SpectEntryPoint(spectClickArea, spectZone, _location.content);
			_entrySpect.goInEvent.addListener(onGoIn);
			_entrySpect.goOutEvent.addListener(onGoOut);
			_location.addPoint(_entrySpect);
		}
		
		// helpers //////////////////////////////////////////////////////////////////////
		
		private function lock():void
		{
			_isLocked = true;
			enabled = !_isLocked;
		}
		
		private function unlock():void
		{
			_isLocked = false;
			enabled = !_isLocked;
		}
		
		private function set enabled(value:Boolean):void
		{
			_entrySpect.content.mouseEnabled = value;
			
			for each (var entry:SpriteEntryPoint in _entries)
			{
 				entry.content.mouseEnabled = value;
			}
		}
		
		private function getPlayerStateId(playerNum:int):String
		{
			return 'player' + playerNum;
		}
		
		private function getContainer(playerNum:int):Sprite
		{
			return _content.getChildByName('playerContainer' + playerNum) as Sprite;
		}
		
		private function getPlace(playerNum:int):MovieClip
		{
			return _content.getChildByName('playerPlace' + playerNum) as MovieClip;
		}
		
		private function getPoint(playerNum:int):Sprite
		{
			return _content.getChildByName('playerPoint' + playerNum) as Sprite;
		}
		
		private function getSpectArea():Sprite
		{
			return _content.getChildByName('spectClickArea') as Sprite;
		}
		
		private function getSpectZone():Sprite
		{
			return _content.getChildByName('spectZone') as Sprite;			
		}
		
	}
}