package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.gameplay.notifications.Notifications;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.McInputMessage;
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	public class SendMessageCommand
	{
		private var _dialog:McInputMessage;
		private var _bandle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _recipients:Array;
		
		public function SendMessageCommand(recipients:Array)
		{
			_recipients = recipients;
		}

		public function execute():void
		{
			_dialog = new McInputMessage();
			_dialog.messageField.maxChars = KavalokConstants.MAX_CHAT_CHARS;
			_dialog.messageField.restrict = Global.serverProperties.charSet;
			_dialog.messageField.text = '';
			_dialog.commitButton.addEventListener(MouseEvent.CLICK, onCommit);
			_dialog.closeButton.addEventListener(MouseEvent.CLICK, closeDialog);
			
			new TextScroller(_dialog.scroller, _dialog.messageField);
			
			_bandle.registerTextField(_dialog.captionField, 'message');
			_bandle.registerButton(_dialog.commitButton, 'send');
			
			Dialogs.showDialogWindow(_dialog);
			
			Global.stage.focus = _dialog.messageField;
			
			if (!Global.notifications.chatEnabled)			
				_dialog.messageField.type = TextFieldType.DYNAMIC;
		}
		
		private function onCommit(e:MouseEvent):void
		{
			if (!Strings.isBlank(inputText))
				sendMessage();
			closeDialog();
		}
		
		private function sendMessage():void
		{
			var showInLog : Boolean = true;
			for each (var recipient:Number in _recipients)
			{
				var command:MailMessage = new MailMessage();
				command.text = inputText;
				new MessageService().sendCommand(recipient, command, true, showInLog);
				showInLog = false;
			}
		}
		
		private function closeDialog(e:Object = null):void
		{
			Dialogs.hideDialogWindow(_dialog);
		}
		
		private function get inputText():String
		{
			return Strings.trim(_dialog.messageField.text);
		}
		
	}
}