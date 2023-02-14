package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	
	public class AgentWarningCommand
	{
		private var _message:String
		private var _okHandler:Function;
		private var _source:String;
		
		public function AgentWarningCommand(source:String, message:String = null, onOk:Function = null)
		{
			_message = message || Global.messages.actionForAgents;
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
				var text:String = "This location is for Agents only!";
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