package com.kavalok.games
{
	import com.kavalok.remoting.ClientBase;
	
	import com.kavalok.events.EventSender;
	
	public class NotReadyClient extends ClientBase
	{
		public static const ID:String = "ready";
		
		public function NotReadyClient(remoteId:String)
		{
			super();
			connect(remoteId);
		}
		
		override public function get id():String
		{
			return ID;
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			var userState:Object = {ready: false};
			processState(userState);
			sendUserState(null, userState);
		}
		
		public function rUserReady(stateName:String, state:Object):void
		{
		}
		
		protected function processState(state:Object):void
		{
		}
	
	}
}