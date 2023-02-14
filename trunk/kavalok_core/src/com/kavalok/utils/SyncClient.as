package com.kavalok.utils
{
	import com.kavalok.remoting.ClientBase;
	
	import com.kavalok.events.EventSender;

	public class SyncClient extends ClientBase
	{
		static private const CLIENT_ID:String = 'sync_client';
		
		private var _readyEvent:EventSender = new EventSender();
		
		private var _charStates:Object = {};
		private var _isReady:Boolean;
		
		private var _actionCounter:int = 0;
		private var _actionId:String = '';
		
		public function get actionId():String
		{
			 return _actionId;
		}
		
		public function set actionId(value:String):void
		{
			 _actionId = value;
		}
		
		public function nextAction():void
		{
			_actionCounter++;
			_actionId = clientCharId + _actionCounter;
		}
		
		public function SyncClient(remoteId:String)
		{
			super();
			connect(remoteId);
		}
		
		override public function get id():String
		{
			 return CLIENT_ID;
		}
		
		public function sendReady():void
		{
			_actionId = actionId;
			_isReady = false;
			sendUserState('rSetReady', { actionId : actionId } );
		}
		
		public function rSetReady(stateName:String, state:Object):void
		{
			checkReady();
		}
		
		override public function charConnect(charId:String):void
		{
			super.charConnect(charId);
			_isReady = false;
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			checkReady();
		}
		
		private function checkReady():void
		{
			if (_isReady)
				return;
			
			for each (var charId:String in remote.connectedChars)
			{
				var state:Object = getCharState(charId);
				if (!state || state.actionId != _actionId)
					return;
			}
			
			_isReady = true;;
			_readyEvent.sendEvent();
		}
		
		public function get readyEvent():EventSender { return _readyEvent; }
	}
}