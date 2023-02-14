package com.kavalok.gameChess
{
	import com.kavalok.gameChess.data.ItemData;
	import com.kavalok.char.Char;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChess.data.PlayerState;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.Debug;
	import com.kavalok.utils.Timers;
	
	public class GameClient extends ClientBase
	{
		static private const STATE_ACTIVE:String = 'activePlayer';
		static private const STATE_ITEM:String = 'item';
		static private const STATE_FORCE_PAWN:String = 'forceSpawn';
		
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
		private var _forcePawnData:ItemData;
		
		override public function restoreState(states:Object):void
		{
			for (var stateId:String in states)
			{
				var isItemState:Boolean = stateId.indexOf(STATE_ITEM) == 0;
				
				if (isCharState(stateId))
					rAddPlayer(stateId, states[stateId]);
				else if (isItemState)
					rAddItem(stateId, states[stateId]);
			}
			
			super.restoreState(states);
		}
		
		public function sendForcePawn(data:ItemData):void
		{
			sendState('rSetForsePawn', STATE_FORCE_PAWN, {data: data});
		}
		
		public function rSetForsePawn(stateId:String, state:Object):void
		{
			if (state.data)
				_forcePawnData = new ItemData(state.data);
			else
				_forcePawnData = null;
		}
		
		public function get forcePawnData():ItemData
		{
			return _forcePawnData;
		}
		
		public function sendAddPlayer(state:PlayerState):void
		{
			sendState('rAddPlayer', getCharStateId(state.id), state);
		}
		
		public function rAddPlayer(stateId:String, state:Object):void
		{
			var index:int = state.index;
			var char:Char = new Char(state);
			
			_numPlayers++;
			_players[index] = char;
			_playerAddEvent.sendEvent(index);
		}
		
		public function sendAddItem(data:ItemData):void
		{
			//trace('s' + GameChess.instance.playerNum + ': ' + data.id);
			
			var stateId:String = STATE_ITEM + data.id;
			sendState('rAddItem', stateId, data);
		}
		
		public function rAddItem(stateId:String, state:Object):void
		{
			//trace('r' + GameChess.instance.playerNum + ': ' + state.id);
			
			_itemAddEvent.sendEvent(new ItemData(state));
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
			_itemActivateEvent.sendEvent(data);
		}
		
		public function rActiveItem(data:Object):void
		{
			safeDispath(_itemActivateEvent, new ItemData(data));
		}
		
		public function sendMoveItem(data:ItemData):void
		{
			var stateId:String = STATE_ITEM + data.id;
			sendState('rMoveItem', stateId, data);
			_itemMoveEvent.sendEvent(data);
		}
		
		public function rMoveItem(stateId:String, state:Object):void
		{
			safeDispath(_itemMoveEvent, new ItemData(state));
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
		
		public function sendFinish(playerNum:int):void
		{
			send('rFinish', playerNum);
		}
		
		public function rFinish(playerNum:int):void
		{
			_victoryEvent.sendEvent(playerNum);
		}
		
		private function safeDispath(event:EventSender, data:ItemData):void
		{
			if (data.playerNum != GameChess.instance.playerNum)
				event.sendEvent(data);
		}
		
		override public function charDisconnect(charId:String):void
		{
			var state:Object = getCharState(charId);
			
			if (state && ('index' in state) && state.index >= 0)
			{
				_numPlayers--;
				_players[state.index] = null;
				_playerRemoveEvent.sendEvent(state.index);
			}
			
			super.charDisconnect(charId);
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