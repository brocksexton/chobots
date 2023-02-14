package com.kavalok.gameChopaj
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChopaj.data.FireData;
	import com.kavalok.gameChopaj.data.ItemData;
	import com.kavalok.gameChopaj.data.PlayerData;
	import com.kavalok.remoting.ClientBase;
	
	public class GameClient extends ClientBase
	{
		static private const STATE_ACTIVE:String = 'activePlayer';
		static private const STATE_ITEMS:String = 'itemsArray';
		
		private var _playerAddEvent:EventSender = new EventSender(PlayerData);
		private var _playerRemoveEvent:EventSender = new EventSender(int);
		private var _playerActivateEvent:EventSender = new EventSender(int);
		
		private var _itemsUpdateEvent:EventSender = new EventSender(Array);
		private var _itemActivateEvent:EventSender = new EventSender(int);
		private var _fireEvent:EventSender = new EventSender(FireData);
		
		private var _victoryEvent:EventSender = new EventSender(int);
		
		public function GameClient()
		{
		}
		
		override public function restoreState(states:Object):void
		{
			super.restoreState(states);
			
			for (var stateId:String in states)
			{
				if (isCharState(stateId))
				{
					rAddPlayer(stateId, states[stateId]);
				}
				else if (stateId == STATE_ITEMS)
				{
					rItems(stateId, states[stateId]);
				}
				else if (stateId == STATE_ACTIVE)
				{
					rActivatePlayer(stateId, states[stateId]);
				}
			}
		}
		
		public function sendAddPlayer(data:PlayerData):void
		{
			sendState('rAddPlayer', getCharStateId(data.id), data);
		}
		
		public function rAddPlayer(stateId:String, state:Object):void
		{
			_playerAddEvent.sendEvent(new PlayerData(state));
		}
		
		public function sendItems(items:Array):void
		{
			sendState('rItems', STATE_ITEMS, {value: items});
		}
		
		public function rItems(stateId:String, state:Object):void
		{
			var result:Array = [];
			for each (var stateData:Object in state.value)
			{
				if (stateData)
					result.push(new ItemData(stateData));
				else
					result.push(null);
			}
			_itemsUpdateEvent.sendEvent(result);
		}
		
		override public function charDisconnect(charId:String):void
		{
			var state:Object = getCharState(charId);
			
			if (state && state.playerNum >= 0)
				_playerRemoveEvent.sendEvent(state.playerNum);
			
			super.charDisconnect(charId);
		}
		
		public function sendActivatePlayer(playerNum:int):void
		{
			sendState('rActivatePlayer', STATE_ACTIVE, {value:playerNum});
		}
		
		public function rActivatePlayer(stateId:String, state:Object):void
		{
			_playerActivateEvent.sendEvent(state.value);
		}
		
		public function sendActiveItem(itemIndex:int):void
		{
			send('rActiveItem', Game.instance.playerNum, itemIndex);
			_itemActivateEvent.sendEvent(itemIndex);
		}
		
		public function rActiveItem(sender:int, itemIndex:int):void
		{
			if (sender != Game.instance.playerNum)
				_itemActivateEvent.sendEvent(itemIndex);
		}
		
		public function sendFire(data:FireData):void
		{
			send('rFire', Game.instance.playerNum, data);
			_fireEvent.sendEvent(data);
		}
		
		public function rFire(sender:int, state:Object):void
		{
			if (sender != Game.instance.playerNum)
				_fireEvent.sendEvent(new FireData(state));
		}
		
		public function sendVictory(playerNum:int):void
		{
			send('rVictory', playerNum);
		}
		
		public function rVictory(playerNum:int):void
		{
			_victoryEvent.sendEvent(playerNum);
		}
		
		public function get playerAddEvent():EventSender { return _playerAddEvent; }
		public function get playerRemoveEvent():EventSender { return _playerRemoveEvent; }
		public function get playerActivateEvent():EventSender { return _playerActivateEvent; }
		
		public function get itemsUpdateEvent():EventSender { return _itemsUpdateEvent; }
		public function get itemActivateEvent():EventSender { return _itemActivateEvent; }
		
		public function get victoryEvent():EventSender { return _victoryEvent; }
		
		public function get fireEvent():EventSender { return _fireEvent; }
	}
	
}