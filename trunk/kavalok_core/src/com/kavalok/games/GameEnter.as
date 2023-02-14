package com.kavalok.games
{
	import com.kavalok.Global;
	import com.kavalok.location.entryPoints.GameEntryPoint;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.Strings;
	
	public class GameEnter extends ClientBase
	{
		private static const DELIMITER:String = "|";
		private static const ID:String = "GameEnter";
		
		protected var gameName:String;
		protected var sessionId:String;
		protected var entryPoint:GameEntryPoint;
		protected var params:Object;
		
		private var _gameStarted:Boolean;
		
		public function GameEnter(gameName:String, sessionId:String, entryPoint:GameEntryPoint, params:Object)
		{
			this.gameName = gameName;
			this.sessionId = sessionId;
			this.entryPoint = entryPoint;
			this.params = params;
			if (sessionId)
				connect(gameName + sessionId);
			else
				connect(gameName);
		}
		
		override public function connect(remoteId:String):void
		{
			super.connect(remoteId);
		}
		
		override public function get id():String
		{
			return ID;
		}
		
		public function startGame():void
		{
			if (!_gameStarted)
			{
				_gameStarted = true;
				var name:String = DELIMITER + gameName + DELIMITER + Strings.generateRandomId();
				send("rStartGame", name);
			}
		}
		
		public function rStartGame(remoteId:String):void
		{
			new NotReadyClient(remoteId);
			var parameters:Object = params || {};
			params.remoteId = remoteId;
			processGameParameters(parameters);
			Global.moduleManager.loadModule(gameName, parameters, true);
//			disconnect(); don't call disconnect it will be called on previous location destroy
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			refreshStartEnabled();
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			refreshStartEnabled();
		}
		
		override public function charConnect(charId:String):void
		{
			super.charConnect(charId);
			refreshStartEnabled();
		}
		
		public function dispose():void
		{
			disconnect();
		}
		
		protected function refreshStartEnabled():void
		{
			entryPoint.startEnabled = remote.connectedChars.length > 1;
		}
		
		protected function processGameParameters(parameters:Object):void
		{
		
		}
	}
}