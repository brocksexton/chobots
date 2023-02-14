package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class BuyConfirmEmeraldsCommand
	{
		private var _handler:Function
		private var _cost:int;
		
		public function BuyConfirmEmeraldsCommand(cost:int, onConfirm:Function)
		{
			_cost = cost;
			_handler = onConfirm;
		}
		
		public function execute():void
		{
			if (_cost > Global.charManager.emeralds)
			{
				Dialogs.showOkDialog(Global.messages.noEmeralds);
				return;
			}
			
			var format:String = Global.messages.buyStuffEmeralds;
			var newEmeralds:int = Global.charManager.emeralds - _cost;
			var text:String = Strings.substitute(format, newEmeralds);
			
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
			dialog.yes.addListener(onBuyEmeraldsAccept);
		}
		
		private function onBuyEmeraldsAccept():void
		{
			_handler();
		}
	
	}
}