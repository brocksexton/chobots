package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	
	public class CitizenWarningCommand
	{
		private var _message:String
		private var _okHandler:Function;
		private var _source:String;
		
		public function CitizenWarningCommand(source:String, message:String = null, onOk:Function = null)
		{
			_message = message || Global.messages.actionForCitizens;
			_okHandler = onOk;
			_source = source;
		}
		
		public function execute():void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else
			{
				var text:String = _message;
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
				dialog.yes.addListener(onOk);
			}
		}
		
		private function onOk():void
		{
				Dialogs.showBuyAccountDialog(_source);
			
			if (_okHandler != null)
				_okHandler();
		}
	
	}
}