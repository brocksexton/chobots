package com.kavalok.gameHunting
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameHunting.data.HealthData;
	import com.kavalok.gameHunting.data.PlayerData;
	import com.kavalok.remoting.ClientBase;
	
	public class GameClient extends ClientBase
	{
		private var _playerCreateEvent:EventSender = new EventSender(PlayerData);
		private var _healthEvent:EventSender = new EventSender(HealthData);
		private var _cancelEvent:EventSender = new EventSender();
		private var _victoryEvent:EventSender = new EventSender(String);
		private var _positionEvent:EventSender = new EventSender(Number);
		
		public function GameClient()
		{
			super();
		}
		
		override public function restoreState(states:Object):void
		{
			super.restoreState(states);
			
			for (var stateId:String in states)
			{
				if (isCharState(stateId))
					rCreatePlayer(stateId, states[stateId]);
			}
		}
		
		override public function get id():String
		{
			return Config.GAME_ID;
		}
		
		public function createPlayer(state:Object):void
		{
			sendUserState('rCreatePlayer', state);
		}
		public function rCreatePlayer(stateId:String, state:Object):void
		{
			_playerCreateEvent.sendEvent(new PlayerData(state));
		}
		
		public function setPosition(position:Number):void
		{
			send('P', clientCharId, position);
		}
		public function P(charId:String, position:Number):void
		{
			if (charId != clientCharId)
				_positionEvent.sendEvent(position);
		}
		
		public function setHealth(data:HealthData):void
		{
			send('rSetHealth', data);
		}
		public function rSetHealth(state:Object):void
		{
			var data:HealthData = new HealthData(state);
			_healthEvent.sendEvent(data);
		}
		
		public function sendVictory(charId:String):void
		{
			send('rVictory', charId);
		}
		public function rVictory(charId:String):void
		{
			_victoryEvent.sendEvent(charId);
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			_cancelEvent.sendEvent();
		}
		
		public function get allStates():Object
		{
			return states;
		}
		
		public function get cancelEvent():EventSender { return _cancelEvent; }
		
		public function get playerCreateEvent():EventSender { return _playerCreateEvent; }
		
		public function get healthEvent():EventSender { return _healthEvent; }
		
		public function get victoryEvent():EventSender { return _victoryEvent; }
		
		public function get positionEvent():EventSender { return _positionEvent; }
	}
	
}