package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.games.GameEnter;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GameEntryPoint extends EntryPointBase
	{
		protected static const GAME_NAME_INDEX : uint = 1;
		protected static const GAME_SESSION_INDEX : uint = 3;
		protected static const DEFAULT_FRAME : uint = 1;
		protected static const ACTIVE_FRAME : uint = 2;
		protected static const DISABLED_FRAME : uint = 3;
		protected static const PARAMS_ID : String = "teleportConfig";

		protected var currentParams : Object = {};

		private var _gameEnter : GameEnter;
		private var _entryName : String;
		private var _gameName : String;
		private var _sessionName : String;
		private var _points : Array = [];
		private var _activeGames : Array = [];
		private var _activePoints : Array = [];
		private var _startEnabled : Boolean = false;
		
		public function GameEntryPoint(location : LocationBase)
		{
			_location = location;
			super(location, prefix, location.remoteId);
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			sendUserState(null, new Object());
			updatePointsState();
		}
		
		protected function get prefix() : String
		{
			return "game_";
		}
		
		protected function get startButton() : MovieClip
		{
			return getStartButton(_entryName.split("_"));
		}
		
		public function set startEnabled(value : Boolean) : void
		{
			if(value != _startEnabled)
			{
				_startEnabled = value;
				if (startButton)
				{
					ToolTips.unRegisterObject(startButton);
					if(value)
					{
						startButton.gotoAndStop(2);
						startButton.addEventListener(MouseEvent.CLICK, onStartClick);
						ToolTips.registerObject(startButton, "clickHereToStartTheGame", ResourceBundles.KAVALOK);
					}
					else
					{
						ToolTips.registerObject(startButton, "standOnTheTeleport", ResourceBundles.KAVALOK);
						startButton.gotoAndStop(1);
						startButton.removeEventListener(MouseEvent.CLICK, onStartClick);
					}
				}
			}
		}
		protected function getStartButton(parts: Array) : MovieClip
		{
			var name : String = "start_" + addSessionPostfix(parts[GAME_NAME_INDEX], parts[GAME_SESSION_INDEX]);
			return MovieClip(GraphUtils.getFirstChild(_location.content, new PropertyCompareRequirement("name", name)));
		}
		
		protected function addSessionPostfix(source : String, session : String) : String
		{
			if(session)
				return source + session;
			return source;
		}
		private function getGameSession(parts : Array) : String
		{
			return (parts.length > GAME_SESSION_INDEX) ? parts[GAME_SESSION_INDEX] : null;
				
		}

		override public function initialize(mc:MovieClip):void
		{
			_points.push(mc);
			GraphUtils.getConfigString(mc, PARAMS_ID);
			var parts : Array = mc.name.split("_");
			
			var startButton:MovieClip = getStartButton(parts);
			if (startButton)
			{
				ToolTips.registerObject(startButton, "standOnTheTeleport", ResourceBundles.KAVALOK);
				startButton.gotoAndStop(1);
			}
				
			MousePointer.registerObject(mc, MousePointer.ACTION);
			mc.enter.gotoAndStop(DEFAULT_FRAME);
		}
		
		override public function destroy():void
		{
			if(_gameEnter)
			{
				_gameEnter.dispose();
				_gameEnter = null;
			}
		}
		override public function goOut():void
		{
			super.goOut();
			if(_gameEnter != null)
			{
				_gameEnter.dispose();
				_gameEnter = null;
			}
			startEnabled = false;
			sendState("rEnterPoint", _entryName, {charId : null, userId : null}, false);
		}
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			updatePointsState();
		}
		override public function goIn():void
		{
			super.goIn();
			_entryName = clickedClip.name;
			var parts : Array = _entryName.split("_");
			_gameName = parts[GAME_NAME_INDEX];
			_sessionName = parts[GAME_SESSION_INDEX];
			if(GraphUtils.hasParameters(clickedClip, PARAMS_ID))
				currentParams = GraphUtils.getParameters(clickedClip, PARAMS_ID);
			
			if(currentParams.premium && !Global.charManager.isCitizen)
			{
				new CitizenWarningCommand(_gameName, null).execute();
			} 
			else
			{
				sendState("rEnterPoint", _entryName, {charId : Global.charManager.charId, userId : Global.charManager.userId}, true);
				sendUserState("rEnterPointUser", {point : _entryName});
			}
		}
		
		public function rEnterPointUser(stateId : String, state : Object) : void
		{
			updatePointsState();
		}
		public function rEnterPoint(pointName : String, state : Object) : void
		{
			updatePointsState();
			if(state.userId == clientUserId)
			{
				Global.frame.tips.addTip("standOnTeleport");
				var pointEnter : MovieClip = _location.content[pointName].enter;
				var coords : Point = GraphUtils.transformCoords(new Point(pointEnter.x, pointEnter.y), _location.content[pointName], Global.root);
				_location.sendMoveUser(coords.x, coords.y);
				_gameEnter = createGameEnter(pointName);
			}
		}
		
		
		private function onStartClick(event : MouseEvent) : void
		{
			_gameEnter.startGame();
			startButton.removeEventListener(MouseEvent.CLICK, onStartClick);
		}
		
		
		private function updatePointsState() : void
		{
			_activeGames = [];
			_activePoints = [];
			for(var name : String in states)
			{
				if(Strings.startsWidth(name, prefix))
				{
					updatePointState(name, states[name]);
				}
			}
			for each(var point : MovieClip in _points)
			{
				var gameName : String = point.name.split("_")[1];
				var frame : uint = DEFAULT_FRAME;
				if(_activePoints.indexOf(point.name) != -1)
				{
					frame = DISABLED_FRAME;
				} 
				else if(_activeGames.indexOf(gameName) != -1)
				{
					frame = ACTIVE_FRAME;
				}
				point.enter.gotoAndStop(frame);
			}
		}
		
		private function updatePointState(pointName : String, state : Object) : void
		{
			var charState : Object = getCharState(state.charId);
			if(state.charId != null 
				&& charState != null
				&& charState.point == pointName)
			{
				_activePoints.push(pointName);
				var parts : Array = pointName.split("_");
				var gameName : String = parts[1];
				if(_activeGames.indexOf(gameName) == -1)
				{
					_activeGames.push(gameName);
				}
			}
		}
		
		protected function createGameEnter(entryName : String) : GameEnter
		{
			return new GameEnter(_gameName, _sessionName, this, currentParams);
		}
		
		
	}
}