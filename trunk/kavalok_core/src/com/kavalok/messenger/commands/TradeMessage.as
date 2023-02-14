package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.windows.TradeWindowView;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	public class TradeMessage extends MessageBase
	{
		private static var bundle : ResourceBundle = Localiztion.getBundle(ResourceBundles.KAVALOK);
		public var remoteId : String;
		
		public function TradeMessage()
		{
			super();
		}
		
		override public function getCaption():String
		{
			 return bundle.getMessage("tradeWith") + " " + sender ;
		}
		
		override public function show():void
		{
			TradeWindowView.showWindow(sender, senderUserId, false, remoteId);
		}
	}
}