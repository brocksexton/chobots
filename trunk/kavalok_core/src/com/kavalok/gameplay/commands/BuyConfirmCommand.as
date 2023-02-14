package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class BuyConfirmCommand
	{
		private var _handler:Function
		private var _cost:int;
		
		public function BuyConfirmCommand(cost:int, onConfirm:Function)
		{
			_cost = cost;
			_handler = onConfirm;
		}
		
		public function execute():void
		{
			if (_cost > Global.charManager.money)
			{
				Dialogs.showOkDialog(Global.messages.noMoney);
				return;
			}
			
			var format:String = Global.messages.buyStuff;
			var newMoney:int = Global.charManager.money - _cost;
			var text:String = Strings.substitute(format, newMoney);
			
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
			dialog.yes.addListener(onBuyAccept);
		}
		
		private function onBuyAccept():void
		{
			_handler();
			Global.addCheck(_cost,"spend");
		}
	
	}
}