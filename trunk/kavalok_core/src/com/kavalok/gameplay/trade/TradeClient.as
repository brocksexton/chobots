package com.kavalok.gameplay.trade
{
	import com.kavalok.gameplay.windows.TradeWindowView;
	import com.kavalok.remoting.ClientBase;
	
	public class TradeClient extends ClientBase
	{
		public var rAddItem:Function;
		public var rRemoveItem:Function;
		public var rAccept:Function;
		public var handleMessage:Function;
		public var onCharConnect:Function;
		public var onCharDisconnect:Function;
		
		public function TradeClient()
		{
			super();
		}

		override public function get id():String
		{
			return TradeWindowView.ID;
		}
		
		override public function charConnect(charId:String):void
		{
			super.charConnect(charId);
			onCharConnect(charId);
		}
		
		override public function charDisconnect(charId:String):void
		{
			onCharDisconnect(charId);
		}
		
		public function get numConnectedChars():int
		{
			 return remote.connectedChars.length;
		}
	}
}