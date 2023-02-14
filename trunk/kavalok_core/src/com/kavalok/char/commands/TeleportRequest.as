package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.messenger.commands.TeleportMessage;
		import com.kavalok.gameplay.KavalokConstants;
			import com.kavalok.messenger.McInputMessage;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.services.MessageService;
	import com.kavalok.gameplay.notifications.Notifications;
	import com.kavalok.localization.ResourceBundle;

	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	public class TeleportRequest extends CharCommandBase
	{

	private var _dialog:McInputMessage;
		private var _bandle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _inviteMessage:String = "#null#";

		override public function execute():void
		{
			//var text:String = Global.messages.teleportSend;
		//	var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
			//dialog.yes.addListener(sendTeleport);
			trace("HI!!!!");
			_dialog = new McInputMessage();
			_dialog.messageField.maxChars = KavalokConstants.MAX_CHAT_CHARS;
			_dialog.messageField.restrict = Global.serverProperties.charSet;
			_dialog.messageField.text = '';
			_dialog.commitButton.addEventListener(MouseEvent.CLICK, onCommit);
			_dialog.closeButton.addEventListener(MouseEvent.CLICK, sendTeleport);
			
			new TextScroller(_dialog.scroller, _dialog.messageField);
			
			_bandle.registerTextField(_dialog.captionField, 'inviteMessage');
			_bandle.registerButton(_dialog.commitButton, 'send');
			
			Dialogs.showDialogWindow(_dialog);
			
			Global.stage.focus = _dialog.messageField;
			
			if (!Global.notifications.chatEnabled)			
				_dialog.messageField.type = TextFieldType.DYNAMIC;
		}

		private function addExtraInfo():void
		{ 
		/*	trace("HI!!!!");
			_dialog = new McInputMessage();
			_dialog.messageField.maxChars = KavalokConstants.MAX_CHAT_CHARS;
			_dialog.messageField.restrict = Global.serverProperties.charSet;
			_dialog.messageField.text = '';
			_dialog.commitButton.addEventListener(MouseEvent.CLICK, onCommit);
			_dialog.closeButton.addEventListener(MouseEvent.CLICK, sendTeleport);
			
			new TextScroller(_dialog.scroller, _dialog.messageField);
			
			_bandle.registerTextField(_dialog.captionField, 'inviteMessage');
			_bandle.registerButton(_dialog.commitButton, 'send');
			
			Dialogs.showDialogWindow(_dialog);
			
			Global.stage.focus = _dialog.messageField;
			
			if (!Global.notifications.chatEnabled)			
				_dialog.messageField.type = TextFieldType.DYNAMIC;*/

		}


		private function onCommit(e:MouseEvent):void
		{
			_inviteMessage = (_dialog.messageField.text.length > 2) ? _dialog.messageField.text : "#null#";
			executeTeleport();
		}

		
		private function sendTeleport(e:Object = null):void
		{
			executeTeleport();
			trace("HI! 1");
		}

		private function executeTeleport():void
		{
			trace("HELLOOO!!!");
			var command:TeleportMessage = new TeleportMessage();
			if(_inviteMessage != "#null#")
			command.text = _inviteMessage;

			new MessageService().sendCommand(char.userId, command, false);

			Dialogs.hideDialogWindow(_dialog);
		}

	}
}