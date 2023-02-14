package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dialogs.LongTextMessage;
	
	public class StartupMessageCommand
	{
		private var _messageId:String;
		
		public function StartupMessageCommand(messageId:String)
		{
			_messageId = messageId;
		}
		
		public function execute():void
		{
			Global.locationManager.firstLocationEvent.addListener(showDialog);
		}
		
		private function showDialog():void
		{
			Global.locationManager.firstLocationEvent.removeListener(showDialog);
			
			var parts:Array = (_messageId in Global.messages) ? Global.messages[_messageId].split('#') : ["Caption", "Text"];
			
			var dialog:LongTextMessage = new LongTextMessage();
			dialog.captionField.text = parts[0];
			dialog.textField.text = parts[1];
			Dialogs.showOkDialog(null, true, dialog);
		}
	}
}