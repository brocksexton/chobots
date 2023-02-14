package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.tips.TipWindow;
	
	
	public class TipMessage extends MessageBase
	{
		public var tipId:int;
		
		private var _window:TipWindow;
		
		public function TipMessage() 
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "laboratory");
		}
		
		override public function show():void
		{
			_window = new TipWindow();
			_window.loadTip(tipId);
			Dialogs.showDialogWindow(_window.content);
		}
		
	}
}