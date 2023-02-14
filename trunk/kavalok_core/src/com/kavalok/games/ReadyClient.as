package com.kavalok.games
{
	import com.kavalok.remoting.ClientBase;
	
	import com.kavalok.errors.IllegalStateError;
	import com.kavalok.events.EventSender;

	public class ReadyClient extends ClientBase
	{
		private var _ready : EventSender = new EventSender();
		private var _sent : Boolean = false;
		
		public function ReadyClient(remoteId : String)
		{
			super();
			connect(remoteId);
		}
		
		public function get ready():EventSender
		{
			return _ready;
		}
		
		override public function get id():String
		{
			return NotReadyClient.ID;
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			if(state == null)
				throw new IllegalStateError("state can not be null");
			sendReady();
		}
		
		protected function sendReady() : void
		{
			sendUserState("rUserReady", {ready : true});
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			checkReady();
		}
		
		public function rUserReady(stateName : String, state : Object) : void
		{
			if(_sent)
				return;
			checkReady();
		}
		
		private function checkReady() : void
		{
			for each(var charId : String in remote.connectedChars)
			{
				var charState : Object = getCharState(charId);
				if(charState == null || !charState.ready)
					return;
			}
			sendReadyEvent();
			disconnect();
		}
		
		protected function sendReadyEvent() : void
		{
			ready.sendEvent();
			_sent = true;
		}
		
	}
}