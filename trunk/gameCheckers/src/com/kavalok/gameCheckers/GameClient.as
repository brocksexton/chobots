package com.kavalok.gameCheckers
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameCheckers.data.ItemData;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.Timers;
	
	public class GameClient extends ClientBase
	{
		static private const STATE_ACTIVE:String = 'activePlayer';
		static private const STATE_ITEM:String = 'item_';
		
		private var _playerAddEvent:EventSender = new EventSender(int);
		private var _playerRemoveEvent:EventSender = new EventSender(int);
		private var _playerActivateEvent:EventSender = new EventSender(int);
		
		private var _itemAddEvent:EventSender = new EventSender(ItemData);
		private var _itemActivateEvent:EventSender = new EventSender(ItemData);
		private var _itemMoveEvent:EventSender = new EventSender(ItemData);
		private var _itemRemoveEvent:EventSender = new EventSender(int);
		
		private var _victoryEvent:EventSender = new EventSender(int);
		
		private var _players:Array = [];
		private var _numPlayers:int = 0;
		
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
				else if (isItemState(stateId))
				{
					rAddItem(stateId, states[stateId]);
				}
			}
			
			var playerNum:int = GameCheckers.instance.playerNum;
			if (playerNum >= 0)
				sendAddPlayer(playerNum);
		}
		
		private function sendAddPlayer(playerNum:int):void
		{
			var charId:String = Global.charManager.charId;
			var state:Object = Global.charManager.getCharState();
			state.playerNum = playerNum;
			sendState('rAddPlayer', getCharStateId(charId), state);
		}
		
		public function rAddPlayer(stateId:String, state:Object):void
		{
			var char:Char = new Char(state);
			var playerNum:int = state.playerNum;
			
			_players[playerNum] = char;
			
			_numPlayers++;
			_playerAddEvent.sendEvent(state.playerNum);
			
			if (_numPlayers == 2 && isMain)
				startGame();
		}
		
		private function startGame():void
		{
			createItems();
			sendActivatePlayer(0);
			//sendActivatePlayer(1);
		}
		
		public function createItems():void
		{
			var itemIndex:int = 0;
			for (var i:int = 0; i < 8; i++)
			{
				for (var j:int = 0; j < 8; j++)
				{
					if ((i+j) % 2 == 0)
						continue;
					
					var playerNum:int;
					
					var stateId:String = STATE_ITEM + itemIndex;
					
					if (i < 3)
						playerNum = 1;
					else if (i >= 5)
						playerNum = 0;
					else
						continue;
						
					//DEBUG: items creation
					//if (itemIndex > 12)
					//return;
					
					var state:ItemData = new ItemData();
					state.index = itemIndex;
					state.row = i;
					state.col = j;
					state.playerNum = playerNum;
					sendState('rAddItem', stateId, state);
					itemIndex++;
				}
			}
		}
		
		public function rAddItem(stateId:String, state:Object):void
		{
			_itemAddEvent.sendEvent(new ItemData(state));
		}
		
		override public function charDisconnect(charId:String):void
		{
			var state:Object = getCharState(charId);
			
			if (state && ('playerNum' in state))
			{
				var playerNum:int = state.playerNum;
				
				if (playerNum >= 0)
				{
					_numPlayers--;
					_players[playerNum] = null;
					_playerRemoveEvent.sendEvent(playerNum);
				}
			}
			
			super.charDisconnect(charId);
		}
		
		public function sendActivatePlayer(playerNum:int):void
		{
			Timers.callAfter(function():void {
				sendState('rActivatePlayer', STATE_ACTIVE, {value:playerNum});
			});
		}
		
		public function rActivatePlayer(stateId:String, state:Object):void
		{
			_playerActivateEvent.sendEvent(state.value);
		}
		
		public function sendActiveItem(data:ItemData):void
		{
			send('rActiveItem', data);
		}
		
		public function rActiveItem(data:Object):void
		{
			_itemActivateEvent.sendEvent(new ItemData(data));
		}
		
		public function sendMoveItem(data:ItemData):void
		{
			var stateId:String = STATE_ITEM + data.index;
			sendState('rMoveItem', stateId, data);
		}
		
		public function rMoveItem(stateId:String, state:Object):void
		{
			_itemMoveEvent.sendEvent(new ItemData(state));
		}
		
		public function sendRemoveItem(index:int):void
		{
			removeState('rRemoveItem', STATE_ITEM + index);
		}
		
		public function rRemoveItem(stateId:String):void
		{
			var strNumber:String = stateId.substr(STATE_ITEM.length);
			_itemRemoveEvent.sendEvent(parseInt(strNumber));
		}
		
		public function get isMain():Boolean
		{
			return Char(_players[0]).isUser;
		}
		
		private function isItemState(stateId:String):Boolean
		{
			return stateId.indexOf(STATE_ITEM) == 0;
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
		
		public function get itemAddEvent():EventSender { return _itemAddEvent; }
		public function get itemActivateEvent():EventSender { return _itemActivateEvent; }
		public function get itemMoveEvent():EventSender { return _itemMoveEvent; }
		public function get itemRemoveEvent():EventSender { return _itemRemoveEvent; }
		
		public function get victoryEvent():EventSender { return _victoryEvent; }
		
		public function get players():Array { return _players; }
		public function get numPlayers():int { return _numPlayers; }
		
	}
	
}